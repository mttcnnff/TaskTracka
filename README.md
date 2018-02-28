# Tasktracka
## This is a basic web app built using the Phoenix Framework made to help keep track of ya tasks!
## Explanation of Part 2 Design Choices:
### Task 1: Managers
* Some users should be managers, who supervise many other users.
  1. **There are some users that are managers, in order to become a manager a user must register and the admin must give them manager status**
  2. **To view all users and their roles go to the /users path. Managers are labeled as @manager.com and the admin is named admin**
* Only a users's manager can assign them a task.
  1. **In order to assign a task to a subordinate a manager must go to the manage page by clicking the "Manage link" in the top right of the screen**
* A user's profile page should show both their manager and a list of people that they manage (underlings).
  1. **To see a users profile page click the profile button on the top right of the screen**
* Managers should be able to see a task report, which shows a table of tasks assigned to their underlings and the status of those tasks.
  1. **The task report is on the left side of the Manage screen. You can get to it by clicking the Manage button on the top right of the screen while logged in as a manager**
  
### Task 2: Detailed Time Spent
* Rather than entering time spent on a task as a single value, users should be able to enter time spent as multiple pairs of (start, end) timestamps. Users should be able to edit and delete these time blocks if they're wrong.
  1. **To add time blocks to a task click the edit button on the list of tasks in a users todo page or a managers manage page. Scroll to the bottom of the edit task page and you'll be able to click a link to add a time block to a specific task.**

* Additionally, there should be direct time tracker feature, where a user can press a "start working" and "stop working" button on the task page, and this should create a block of time spent working on the task. The "stop working" button should be implemented using jQuery's AJAX function.
 1. **Click the start or stop button on the task card in the todo view (for users) or the manage view (for managers). This will use JQuery to create a time block and close off an open time block. The page reloads to make rendering a new button with eex templates possible.**

* Tracking time only in 15-minute increments is no longer required.
  1. **I left it in to make less work for myself**














To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
