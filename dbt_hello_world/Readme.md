# Welcome to your new dbt project!

This is a basic configuration project, so you may feel inspired and motivated to start with dbt today. This is also my start with dbt, and I hope it gives you the answers you are looking for.
You will find comments throughout the project, in Portuguese or English. It depends on my rush to understand the ideas. 

__

## How it works

* dbt works on top of your engine solution (Redshift, Postgres, Cluster Spark), because it won't run your queries, the engine will.
* It runs the SQL code and controls the dependency among several queries.
* It's possible to make snapshots, so you can work with historical dimensions.
* You can build transformations that will update with an incremental refresh.

<img src="https://github.com/cathfoliveira/dbt_data_tool/blob/main/dbt_hello_world/dbt_workflow.png" alt="dbt_workflow.png">
__

## Install your dbt

* Run `pip install dbt`
* Create your project folder and run the `dbt init <project_name>` 
* Check the created directories using `ls -l <project_name>`
* Verify if the `.dbt\profile.yml` was created in your local account. That is where you'll need to add your (Redshift) credentials. The attribute `threads` receives a number indicating how many paralel queries dbt will execute.

__

## Test your solution

* Create a staging environment to build the heavy transformations in [models](.\models\staging). Follow the example to build a general SQL that will adjust to your scenario.
* Follow the same idea used in the file [stg_atomic_event.sql](.\models\staging\stg_atomic_events.sql). Specify the types you wanna import, rename the columns at your preference and patterns.
* Make sure you're at your project (cd..)
* Run your model by executing `dbt run`.
* It'll create the SQL compiled in [target folder](.\target\compiled\dbt_hello_world\models\staging). If you haven't ran the code, it won't show. ;)
* At this point, if your code creates a table, you may check your database, the new schema and table will be there.
* Now you might see the Tips below and proceed by creating a `mart` folder inside the models' directory. The tables/views created here must use the staging SQL as the source and these are the tables/views to be create in the database.
* If you're using some package like [dbt_utils](https://github.com/dbt-labs/dbt-utils), you'll need to install it:  `dbt deps`. Don't forget to create the [packages.yaml](\packages.yaml) declaring your packages.
* Create your *.sql file with your transformation and test it with `dbt compile`.
* Try executing `dbt test`after running your model to see if the tests you declared at staging will pass.

__

## Tips

* Develop queries using the compatible SQL for your database.
* In Staging, build the modeling with the right names, types, and cleaning needed. 
* In Staging, don't apply filters and business rules. Make it general, because if you need to add a new column or change a column's name, this will be the place to do it. 
* Study the possibility to only materialize/create a table in the mart level. Keep the staging ephemeral.
* Use the directory `tests`to create your queries and test the data.
* `dbt run` executes all the models. Having only conversion.sql to be executed, try `dbt run -m conversion`. But it won't run the dependencies, in this case specify a sign indicating all the dependecies that came before or after the conversion.
```
-- run all the upstream dependencies (before) with the conversion
dbt run -m +conversion

-- runs all the downstream dependencies (after) with the conversion
dbt run -m conversion+

-- runs all the upstream and downstream dependencies with the conversion
dbt run -m +conversion+

-- runs all but xyz.sql model
dbt run -m +conversion+ -e xyz
```

Go to [dbt Best Practices](https://docs.getdbt.com/docs/guides/best-practices) to learn more.

__

## Documentation

* dbt creates a HTML in your target directory with columns, descriptions, type of each column, and a sample showing how to use the solution.
* Thinking about automatizing? Develop a CI/CD in tests to generate the documentation on every build.
* Copy the index.html to a bucket S3 and create a website for end-users consumption.

```
-- generates the doc
dbt docs generate

-- creates a server to show the index.html 
dbt serve
```

## References
- [getdbt Website](https://www.getdbt.com/).
- [How Bootcamp & André Sionek](https://learn.howedu.com.br/curso/engenharia-de-dados)
