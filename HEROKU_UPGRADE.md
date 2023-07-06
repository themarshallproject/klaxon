# Heroku Transition Guide

Those of you who are still running Klaxon on free Heroku tiers have likely received messages telling you that the free services will soon be wound down. We have considered a few options to work around this, but we haven't found a good way to mitigate this issue while keeping Klaxon as easy to deploy and maintain as can be. After six years of being able to run this at no cost at all, it looks like you will now have to pay a small fee to continue to do so. We will keep investigating other avenues for the future of Klaxon, but for now, you'll have to pay.

On Nov. 28th, Heroku will stop running free apps, so you have to make a couple of small tweaks to your setup before then. Here's what you'll need to do:

- Log into your Heroku dashboard at https://dashboard.heroku.com/apps/
- Click on your Klaxon app
- Click the "Resources" tab along the top of the page (between "Overview" and "Deploy")
- You should see a list of services that run as part of your setup. First, you'll need to click "Change Dyno Type" It will present you with a menu of options. You'll probably want to choose "Eco". This will cost you $5 per month and can be shared across several apps, if you're using Heroku for any other free programs. It will also put your web app to sleep if someone doesn't visit for 30 minutes (this is the same way the free-tier dynos worked). But it should keep your Klaxon scheduler and notifier running as expected.
- Many of you have likely already outgrown the 10,000-row database limit for the free Postgres starter plan. If, however, you're still using that free database, you'll need to upgrade that too. Look at the line that says "Heroku Postgres". You should see an orange alert on the right-hand side of the table that reads "Hobby Dev". Click the menu button to the right of the word "Free" and choose "Modify Plan". There you'll need to change your plan name from "Hobby Dev" to "Mini" and click "Provision". The Mini Postgres plan costs about $5 a month for 10,000 rows. When you outgrow that database, you can upgrade to the Basic Postgres plan for about $9 a month.

We hope this helps you get everything sorted to keep your Klaxon running. If you have questions or need a hand with these changes, reach out to Tom directly, and we'll do our best to help you troubleshoot.
