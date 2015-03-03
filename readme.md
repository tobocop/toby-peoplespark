# View App - (https://peoplespark.herokuapp.com/)

## Code Improvements
 - refactor offices to not trigger queries on filter
 - idea creation should move to service. Getting to be to much business logic in the controller
 - Unit tests for JS
 - Use a templating language for JS (handlebars, reacts built in one, angular's) to avoid re-setting index params in the create controller

## Style and JS improvements
  - Layout breaks at smaller resolutions. Make responsive or set min-widths on column
  - gzip CSS and js
  - make z-index vars for consistency
  - Custom checkboxes instead of browser default

## Feature improvements:
  - ajax filtering of status's and office locations ( only load center content )
  - Ajax add idea form submit, reload only center ideas after submit



##Problem Approach

I wanted to solve this problem as close to what I would do in real life as possible. I coded this application exactly as I would if it was given to me to launch into production. That means 100% automated test coverage, and strong object oriented principles instead of all rails all the time. Although I did not deliver as many features as I'd have hoped, the code delivered is an extremely accurate representation of the quality and care I take when coding.

My first step was setup. Rails app with capybara and rspec for testing, local postgres instance with 2 DB's (dev and test), and a failing spec to start driving my code from. Onto my first task, get the idea creation working, as I'd need that anyway to generate test data for the idea filtering. On the idea I choose to use a state machine to handle the various workflow points an idea seemed to have with it. State machines allow you to assign a given point in a workflow to an object (and ultimately the database record). You can do this with a type_id or state_id field and lookup, but a state machine has a few advantages. First your states are enforced via code, which means they all have automated tests behind them. Second, when changing states (say form under_consideration to planned), it's extremely easy to add dynamic logic to trigger other events. An example could be notifying the person who submitted it that it is now being planned, and to notify the employees managers that they need to start planning an idea. Handling this logic in a state machine gives the benefit of modeling all of the objects behavior in a single place, apposed to separate services, triggers, and hooks.

After a bare bones CRUD for ideas was working, I moved onto the filtering. If you look through my git commits, moving from state only filtering to state and office filtering involved several refactors of the ideas_controller. Eventually I landed on an approach I use a lot, a service and a presenter. The IdeaService is responsible for taking in the params from the form and making sense of them, then calling the appropriate database models for what it needs. Ultimately then, it combines all that together and passes it back up the chain to the controller. This keeps the controller only worried about flow logic rather then business logic (business logic being what the params are and what significance they have, how the results are ordered, how many to show, etc.). Your business logic stays in the service, which makes the business logic and controller easier to test (yay!). Once you get the database objects back, I like to wrap them in a presenter object. The reason for this is I like my view templates to be dumb, and a lot of times we store things in a way that's not optimized for viewing. Using a presenter object for an idea allows me to encapsulate all of the tiny data manipulations needed to display the idea in a nice way. This also typically removes the need for if statements and branching logic in your view, keeping html and CSS duplication low. Something like displaying an anonymous submission could be a DB check, or an if statement in-line in the view, but using a presenter I'm left with a simple one liner that encapsulates how to display who submitted the idea. The view doesn't care if it was anonymous, it only wants to display a string that shows who submitted this idea. It also allows for messy things like changing the CSS class to toggle the different state tags (the orange, blue, purple, etc. tags on the idea list) to be cleaned up into a single function instead of cluttering up the view.

All of this was great and I was happily coding along until I realized I had already used up the majority of my time without writing any CSS or JavaScript. After a bit of cleanup with how offices worked, I dove into CSS. I love CSS and can talk for days about best practices. For this since the mock was simple, I went with lots of short CSS files (for buttons, typography, lists etc.) using name spaced classes and a flat hierarchy to prevent too much specificity. This allows a lot of flexibility to override things and make changes quickly. It's nearly impossible to write perfect CSS at first, so it's important to keep your structure flexible. Not using html tags or ids to target elements, and name spacing your component allows for easy CSS refactoring in the future once the patterns become more apparent.

So I have rails and CSS, time for JavaScript. With not having much time left, I decided not to dive into learning angular (though I happily will). Instead I went for the main JavaScript component outlined in the requirements, a modal popup. Rather then pulling in a plugin I wrote an extremely simple modal from scratch. It saves on file size and is perfectly suited for most modal dialog uses. I name spaced all of my JavaScript to a Peoplespark global var to prevent pollution of the global name space, and used a straight JavaScript object and jQuery plugin type syntax I've been successful with in the post. If I knew there would be lots of modals on a given page, I'd change the modal object to use prototypical inheritance to improve performance of memory usage, however given the small nature of the page right now, I did not want to optimize prematurely.

Although I did not provide the amount of features I would have liked, this was very much a real world example for me. Everything started out in perfect development land, and then once the deadline came closer, compromises had to be made to get a working and pleasing feature set out. I chose to not sacrifice code quality for more features.







