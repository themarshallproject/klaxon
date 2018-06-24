Due to an oversight on our part in the upgrade procedures (sorry!) there are some additional steps required to upgrade from version 0.1.0 or version 0.2.0. The issue is that rails migrations (tasks that update the database schema) are not getting run automatically. As of v0.2.1 any new deployment will be configured to run these migrations automatically.

To make sure migrations get run after each deploy, follow these steps.

1. Go into the 'Settings' tab for the klaxon app on dashboard.heroku.com.
2. In the 'Buildpacks' section click on 'Add Buildpack'
3. Enter `https://github.com/gunpowderlabs/buildpack-ruby-rake-deploy-tasks` into the text box that pops up and click 'Save Changes'.
4. In the 'Config Variables' section click on 'Reveal Config Vars'.
5. In the empty text boxes at the bottom, enter `DEPLOY_TASKS` on the left and `db:migrate` on the right. Click 'Add'.
6. To actually run the migration trigger a manual deploy from the bottom of the 'Deploy' tab by clicking 'Deploy Branch'. The line
   ```
   ActiveRecord::SchemaMigration Load (0.6ms)  SELECT "schema_migrations".* FROM "schema_migrations"
   ```
   should appear in the build log. If you have pending migrations, this will be followed by the log   output for them as well.
7. That's it, you should be all set going forward.
