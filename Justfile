
rscript := `which Rscript`


[group('renv')]
_snapshot:
    #!/usr/bin/bash

    {{rscript}} -e "renv::snapshot()"

[group('renv')]
restore:
    #!/usr/bin/bash

    {{rscript}} -e "renv::restore()"