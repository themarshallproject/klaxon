## How Klaxon works

Klaxon is a tool that enables journalists and researchers to monitor scores of websites for noteworthy changes. When it finds something new on one of the pages it's watching, it saves a version of it, or a "snapshot,” and emails an alert and pings a Slack channel.

#Bookmark Set-Up

Working with Klaxon requires the one-time setup of a bookmarklet. Once the bookmarklet is added to your browser, clicking on it will allow you to save a page.

To add the bookmarklet, visit the Klaxon website. The first time you visit you'll notice a box that says “Watch Your First Item.” Underneath that, you’ll see a button that says “Add to Klaxon.” Click and drag that button to the bookmarks bar on your browser. Now anytime you’re on a site you want follow through Klaxon, you can click on the bookmarklet *without having to leave the site*. This works similarly to services like Digg and Pinterest.

Clicking on the bookmark will open a popup on the right side of your browser window. As you move your mouse around the page, different sections are highlighted. Web pages have images, files, tables and text that live in specific sections of the HTML document. With your mouse, you can select a table row (tr), paragraph (p), headline (h2) or the whole body of text (body). These selectors tell Klaxon *which* part of the page to follow, so you’ll only get alerts when that specific section changes. To tell Klaxon where to look, hover your mouse over different sections of the page. Notice how each section is highlighted in red when you hover. This is one indicator to help Klaxon home in on the right area.

![Example of choosing an element to watch](/images/bookmarklet.png)

When you think you have highlighted the correct section of the page—say the list of Supreme Court decisions, or the latest documents in next year’s state budget—click the mouse. Now, look under the “Save and Edit” box in the Klaxon window, and you’ll notice it says “Done!” That means that Klaxon has saved this page and will start watching it for you.

Before you close the window though, see the red box under the heading “Content Preview?” That shows you what information is captured in the section of the page you selected. If the words you see in the red box don’t match what you’re hoping to monitor, you might have chosen the wrong part of the page. Not to worry, you can hover and click on any different section of the page until you get the right area selected and saved.

For the last step, you’ll want to click the ‘Save and Edit’ button, which will bring you back to Klaxon so you can give this page a name (like a slug) in the system.

## The Feed

In [the Feed](/) you'll find a list of recent snapshots of pages people in your newsroom are following. This is a good place to see what’s new in the system and to discover and subscribe to Klaxons that other reporters or editors find useful. These links are in order of most recent changes. You will also get a team summary of how many changes have been monitored, the number of pages the team is following and how many users are using Klaxon.

If you want to step back through each stage of the site’s evolution, you can explore its history on the “[Watching](/watching/pages)” page.

## Watching

The “[Watching](/watching/pages)” page displays a list of all the pages that your newsroom is monitoring (as opposed to a chronological stream of the latest updates as seen in the [Feed](/)). Here you can also change settings for individual pages.

To change the name or URL of any of the Klaxons you’ve created or to adjust their notification settings, simply click the “Edit” button next to the appropriate page. You can also click into each to view the differences of each snapshot the system has collected since you added it to Klaxon.

To see what’s updated on each page, you can click the “Latest change” button. This brings you to a comparison of the most recent two snapshots of the page. Anything that was added to the page is highlighted in green. Anything that was removed from the page is in red. It can take a little bit of practice to become accustomed to looking at the page’s underlying HTML in this manner. If you’re subscribed to get emails about the Klaxon for this page, you’ll also receive an email for this difference in the email every time the page changes.

To make it easier to keep track of what’s significant about each change and to spare your colleagues from having to parse it themselves, you can add a note to it. Near the top of the page, looking for the text box next to the words “What’s changed”. You can put your note in that box, say “Candidate X’s name removed from the council minutes” and hit “Save.” Now that note will be visible with that snapshot in the system or when it shows up in the Feed, tipping others that it’s worth taking a look.

#Adding Klaxon Manually

In the “[Watching](/watching/pages)” page you can manually add sites to monitor if you already know which CSS Selector on the page you want to follow or are having difficulty with the bookmarklet.

Click on "Manually Watch and Item" on the right side of the heading. This will take you to directly to the Edit page for links. Here you can include the title, link to the site and the specific selector(s) you want to focus on.

If you want to ignore changes within your chosen selector(s), enter another selector into the "Exclude selector" input.

## Understand what’s changed on a page

Sometimes you want to see how the current version of a site compares to a version that you captured, say, six months ago. Because Klaxon stores each snapshot it finds of a site, this is fairly easy to do. You can reach the history of snapshots in a couple of ways. If it’s a site someone else in your newsroom is following, from the Feed, click on the latest snapshot you see for your site, which would say something like “GA Sec’y of State changed” or “The Marshall Project changed”. If it’s a site you added to Klaxon, from the “Watching” page, click on the “Latest snapshot” button next the site you want to explore. Either of these routes takes you to the most recent snapshot for that site.

Now, click the “Past snapshots” button in the upper right corner. This takes you to a list of every snapshot Klaxon has captured of the site in question.

![Example of comparing two snapshots](/images/compare_versions.png)

First, select the “older” version from the left column that you want to be the basis of comparison. Then, in the right column, select the “newer” snapshot from the list. Finally, click the compare button. This takes you to a new page to compare the snapshots. The difference between the two pages will be displayed just as it is in the “Latest snapshot” page: additions to the site will be highlighted in green, deletions will be marked in red. Using the “Past snapshots” list, you can step through every change, one at a time, to find the update you’re looking for.  When you find what you’re looking for, add a note in the “What’s Changed” field to make it easier to find later when you need it.

## How to add notifications to a Slack channel

Click on the “Settings” button in the upper right corner of the page and choose “Integrations” from the menu. On the Integrations page, click the “Create Slack Integration” button. You can add an integration for any number of channels in your newsroom’s Slack. For each one, you just have to set up an Incoming Webhook. In Slack, click on the dropdown arrow in the upper left corner and choose “Apps & Integrations” from the menu. This will open a new window in your browser for you to search the Slack app directory. In the search box, type “Incoming Webhooks” and choose that option when it pops up. If you already have webhooks, you’ll see a button next to your Slack organization’s name that says “Configure.” Otherwise, click the green button that says “Install”.

Now, choose the channel that you want the Klaxon alerts to go to from the dropdown menu. We’d recommend that you not send them to #General, but maybe create a new channel called #Klaxon. After you create or choose your channel, click the green button that says “Add Incoming Webhooks Integration”. Near the top of the next screen, you should see a red URL next to the label “Webhook URL”. Copy that URL and switch over to your browser window with Klaxon in it. Paste the URL into the box labeled “Webhook URL,” and type the name of the channel you want your Slack alerts to go to into the “Channel” box (this should be the same channel name you used in Slack when you created the integration). Now click the “Create Slack Integration Button”. Now you should be all set. If you want to have the ability to send Klaxon alerts to other channels, for specific reporting teams or for certain projects, you can repeat this process.

## How to remove an alert
If you find that you have set an alert in error, or you are no longer using it and want to clear out space, you can delete any alert. From the "Watching" page, click on the "Edit" button next to the alert you want to remove. Then scroll to the bottom of the Edit page and look for this button: ![Klaxon delete button](/images/delete_button.PNG) 

It should do the trick and will remove the alert and it's stored snapshots from the database.

## About Klaxon

Built and refined in the newsroom of [The Marshall Project](https://www.themarshallproject.org/#.2N8GFLsI0), Klaxon has provided our journalists with many news tips, giving us early warnings and valuable time to pursue stories. The public release of this free and open source software was supported by Knight-Mozilla [OpenNews](https://opennews.org/). With feedback or suggestions, contact us with the form below. To help improve Klaxon for other users, whether you’re a coder or not, read [our guide to how you can contribute to the project.](https://github.com/themarshallproject/klaxon/blob/master/CONTRIBUTING.md)

## Upgrading Klaxon

When we release major changes to Klaxon, we’ll make an announcement to our [Google Group email list](https://groups.google.com/forum/#!forum/news-klaxon-users). At that point, you’ll likely want to adopt those in your system as well. To do that, you can find [everything you'll need to upgrade here](https://github.com/themarshallproject/klaxon#applying-upgrades-as-the-project-develops).

## Bookmarklet not working?

In some cases, certain Chrome extensions may break the bookmarklet.
It may look something like this:

![example of broken bookmarlet](https://user-images.githubusercontent.com/190733/28034680-8375a8a2-6577-11e7-86fd-c594d35bd4b1.png)

For example, the Electronic Frontier Foundation's ["Privacy Badger"](https://www.eff.org/privacybadger) is a script blocker. When you use Klaxon in addition to Privacy Badger, the extension detects Klaxon as a script and blocks it. This breaks the service.

The solution:

Whitelist your organization’s specific Klaxon in Privacy Badger.

To do this, click on the Privacy Badger icon in your Chrome extension bar. A dialog box should appear. Click the gear in the upper right hand corner of the dialog box. This will open Privacy Badger Settings in a new tab.

![Privacy Badger Dialog box](/images/privacy_badger_dialog.PNG)

There should be a tab for "Whitelisted Domains" in your Privacy Badger settings. Go to that and add your organization's Klaxon (XXX-klaxon.herokuapp.com) to it. Click add domain.

![Privacy Badger Dialog settings](/images/privacy_badger_settings.PNG)

This should fix this issue. Apply the same logic for other ad-blocking, tracking-prevention extensions that might cause Klaxon to not work.

For further reference on these issues, refer to issues [#135](https://github.com/themarshallproject/klaxon/issues/135) and [#138](https://github.com/themarshallproject/klaxon/issues/138).
