{ stdenv, pythonPackages, fetchurl, coreutils, plugins ? [] }:

pythonPackages.buildPythonApplication (rec {
  name = "${pname}-${version}";
  pname = "buildbot";
  version = "0.9.0rc4";
  src = fetchurl {
    url = "mirror://pypi/b/${pname}/${name}.tar.gz";
    sha256 = "16bnrr5qkfpnby9sw9azcagnw0ybi7d8bpdlga2a4c61jg2d5dnc";
  };

  buildInputs = with pythonPackages; [
    lz4
    txrequests
    pyjade
    boto3
    moto
    txgithub
    mock
    setuptoolsTrial
    isort
    pylint
    astroid
    pyflakes
  ];

  propagatedBuildInputs = with pythonPackages; [

    # core
    twisted
    jinja2
    zope_interface
    future
    sqlalchemy
    sqlalchemy_migrate
    future
    dateutil
    txaio
    autobahn

    # tls
    pyopenssl
    service-identity
    idna

    # docs
    sphinx
    sphinxcontrib-blockdiag
    sphinxcontrib-spelling
    pyenchant
    docutils
    ramlfications
    sphinx-jinja

  ] ++ plugins;

  preInstall = ''
    # writes out a file that can't be read properly
    sed -i.bak -e '69,84d' buildbot/test/unit/test_www_config.py

    # re-hardcode path to tail
    sed -i.bak 's|/usr/bin/tail|${coreutils}/bin/tail|' buildbot/scripts/logwatcher.py
  '';

  postFixup = ''
    mv -v $out/bin/buildbot $out/bin/.wrapped-buildbot
    echo "#!/bin/sh" > $out/bin/buildbot
    echo "export PYTHONPATH=$PYTHONPATH" >> $out/bin/buildbot
    echo "exec $out/bin/.wrapped-buildbot \"\$@\"" >> $out/bin/buildbot
    chmod -c 555 $out/bin/buildbot
  '';

  meta = with stdenv.lib; {
    homepage = http://buildbot.net/;
    description = "Continuous integration system that automates the build/test cycle";
    maintainers = with maintainers; [ nand0p ryansydnor ];
    platforms = platforms.all;
    license = licenses.gpl2;
  };
})
