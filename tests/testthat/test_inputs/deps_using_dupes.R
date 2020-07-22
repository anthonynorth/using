using::pkg(qfes, min_version = "0.2.1", repo = "https://github.com/qfes/qfes.git")
using::pkg(ffdi, min_version = "0.1.3", repo = "https://qfes@dev.azure.com/qfes/packages/_git/ffdi")
using::pkg(rdeck, min_version = "0.2.3", repo = "https://github.com/anthonynorth/rdeck.git")

## as above genuine dupe
using::pkg(qfes, min_version = "0.2.1", repo = "https://github.com/qfes/qfes.git")

## different version
using::pkg(ffdi, min_version = "0.1.4", repo = "https://qfes@dev.azure.com/qfes/packages/_git/ffdi")

## different repo
using::pkg(rdeck, min_version = "0.2.3", repo = "c:/rdeck/")
