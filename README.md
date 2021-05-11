# QUIZ-MAXX
> A sample Quiz Application for demonstration of design and coding style 😎

## Environment
- Ruby 2.6.6
- Rails 6.0


## Setup

In order to setup application downloading the appropriate ruby/rails you may execute the following:

```shell
./bin/setup
```

This will drop the database, load the schema and run seed the database, all of which you may do manually.




## Sample Accounts & Data

Seeding the database creates sample testing data as well as two defualt accounts, one admin.

```text
login: admin@neilab.com
password: 'password'
```



And a sample student account:

```text
 login: student@neilab.com
 password: 'password'
```

## Architecture 

The Application utilizes ActiveAdmin for administration and Devise for authentication. Quiz scores and  managed using QuizService which contains a DSL for building data and helper methods for each respective model. In particular, for grading a quiz, the :grade_submission or :build_submission methods are used.

## Testing

Tests are written in *Rspec* and *FactoryBot*, with primary testing functionality existing in the QuizService spec.

> spec/services/quiz_service_spec.rb 

You may run test using rspec:

```shell
rspec 
...

Finished in 0.15053 seconds (files took 0.82938 seconds to load)
3 examples, 0 failures

```