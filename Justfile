
rscript := `which Rscript`


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