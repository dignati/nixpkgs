{ kdeFramework, lib, ecm, kconfig, kcoreaddons
, ki18n, kio, kservice, plasma-framework, solid
, threadweaver
}:

kdeFramework {
  name = "krunner";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ ecm ];
  propagatedBuildInputs = [
    kconfig kcoreaddons ki18n kio kservice plasma-framework solid
    threadweaver
  ];
}
