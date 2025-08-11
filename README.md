# liquibase-mariadb-demo

data refers to: https://relational.fel.cvut.cz/dataset/IMDb

# Commands

- `docker run -v ./changelog:/liquibase/changelog -v ./liquibase.properties:/liquibase/liquibase.properties liquibase/liquibase:4.33-alpine --defaults-file=liquibase.properties  update`