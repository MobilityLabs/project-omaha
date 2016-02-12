# project-omaha

A gem which adds bespoke functionality to commenting, based on acts_as_commentable_with_threading.

To use:

 - Run  `rails generate acts_as_commentable_with_threading_migration_generator`.
 - Adjust the `MAX_DEPTH` variable inside of the `Comment` model to your preference.

Documentation can be found at [the original repository!](https://github.com/elight/acts_as_commentable_with_threading)


# Key differences

  - Instead of requiring a single `User`, all comments can belong to a `commentator`.  To facilitate this, change your models from this:

     ```
     class User
       has_many :comments
     ```

     to this:

     ```
     class User
        has_many :comments, as: :commentator
     ```

    By default, the commentator is required.


This project is licensed under the MIT license.