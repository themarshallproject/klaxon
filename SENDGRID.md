We've been having issues with the way existing Heroku applications authenticate to the Sendgrid Heroku plugin by default. Something seems to have changed recently in that process. Note that new applications do not appear to be affected. If you're emails are not sending properly (which you can test simply by trying to log in), you may need to follow these steps.

1. From the Heroku application page, click on the "Resources" tab, and click the link to the Sendgrid plugin, this will take you to the Sendgrid website.
2. In the left hand column choose Settings -> API Keys. Click the blue "Create an API Key" button in the top right corner.
3. In the form that appears fill in the API key name (doesn't matter what you name it), make sure the "Full Access" option is selected, and click "Create & View".
4. Click the API key to copy it to your clipboard. Then navigate back to Heroku.
5. In the "Settings" tab of your Heroku app click the "Reveal Config Vars" button.
6. Change the `SENDGRID_PASSWORD` variable to the API Key by clicking the pencil icon next to it, pasting it in, and saving it.
7. Change the `SENDGRID_USERNAME` variable to the string "apikey" in the same manner.

You should be all set! Confirm that your changes worked as expected by trying to log in again, and ensuring that the login email arrives as expected.
