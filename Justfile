
rscript := `which Rscript`


[group('devcontainer')]
_libicu:
    #!/usr/bin/bash
    dnf install -y https://kojipkgs.fedoraproject.org//packages/libicu67/67.1/10.el10_0/x86_64/libicu67-67.1-10.el10_0.x86_64.rpm

[group('devcontainer')]
_languageserver:
    #!/usr/bin/bash
    {{rscript}} -e "install.packages('languageserver')"

[group('devcontainer')]
devcontainer: _libicu _languageserver

[group('renv')]
_snapshot:
    #!/usr/bin/bash

    {{rscript}} -e "renv::snapshot()"

[group('renv')]
restore:
    #!/usr/bin/bash

    {{rscript}} -e "renv::restore(repos=getOption('repos'))"

[group('build')]
render $file:
    #!/usr/bin/bash

    {{rscript}} -e "rmarkdown::render('${file}')"