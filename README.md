# liquibase-mariadb-demo

data refers to: https://relational.fel.cvut.cz/dataset/IMDb

## Changelog format

- Written using SQL
- Object-oriented changelog

## Commands

### Implement all changes


```sh
docker run -v ./changelog:/liquibase/changelog -v ./liquibase-example.properties:/liquibase/liquibase.properties liquibase/liquibase:4.33-alpine --defaults-file=liquibase.properties  update
```

### Implement {n} changes

```sh
docker run -v ./changelog:/liquibase/changelog -v ./liquibase-example.properties:/liquibase/liquibase.properties liquibase/liquibase:4.33-alpine --defaults-file=liquibase.properties  update-count --count={n}
```

### Rollback {n} changes

```sh
docker run -v ./changelog:/liquibase/changelog -v ./liquibase-example.properties:/liquibase/liquibase.properties liquibase/liquibase:4.33-alpine --defaults-file=liquibase.properties  rollback-count --count={n}
```

### Check for unimplemented changes

```sh
docker run -v ./changelog:/liquibase/changelog -v ./liquibase-example.properties:/liquibase/liquibase.properties liquibase/liquibase:4.33-alpine --defaults-file=liquibase.properties status
```

### Check changes history

```sh
docker run -v ./changelog:/liquibase/changelog -v ./liquibase-example.properties:/liquibase/liquibase.properties liquibase/liquibase:4.33-alpine --defaults-file=liquibase.properties history
```

### Validate changes using test script

```sh
docker run -v ./changelog:/liquibase/changelog -v ./liquibase-example.properties:/liquibase/liquibase.properties -v ./scripts/test-update-rollback.sh:/test.sh liquibase/liquibase:4.33-alpine /test.sh
```
