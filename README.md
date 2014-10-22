# Tinytest In App Meteor Package

Use Tinytest to test your Meteor app, just like you would a package.

Does not use Velocity so the tests do NOT run in a mirror. You must clean up
any data you create. If you would like to use Velocity with Tinytest in your
app, see my [numtel:velocity-tinytest package](https://github.com/numtel/velocity-tinytest).

## Installation
The `tinytest` package is also required. Install both using this command:

```bash
$ meteor add tinytest numtel:tinytest-in-app
```

## Quick start

1. Add a test to your application in any file
    ```javascript
    Tinytest.add('test title', function(test){
      test.equal(true, true);
    });
    ```

2. Open the Javascript console in your browser, execute `runTinyTest()`

## Implements

#### runTinytest({...})

Run your tests on the server and in a PhantomJS client then output the results
to the console. PhantomJS loads the application on the origin of the URL you are
browsing from. For example, if your browser is at `http://localhost:3000/posts/someid`,
PhantomJS will open `http://localhost:3000` and execute the tests.

**Options:**

Key    | Description
-------|----------------------------------------------------------------------
`pathPrefix` | Specify array of strings to narrow the range of tests to execute. For example, if your test was titled `FirstPart - some test`, pass `['tinytest', 'FirstPart']` to only run the tests that begin with `FirstPart - `.

## Tinytest documentation

Since there is no official documentation for Tinytest, it may be helpful to have
some here.

Test titles can be any string. Using a separator of `" - "` will allow running
a subset of tests using the `pathPrefix` option.

**Test Syntax:**
```javascript
// Synchronous test
Tinytest.add('test title', function(test){
  test.equal(true, true);
});

// Asynchronous test
Tinytest.addAsync('async test title', function(test, onComplete){
  Meteor.setTimeout(function(){
    test.equal(true, true);
    onComplete();
  }, 1000);
});
```

**Assertions:**
```javascript
test.isFalse(v, msg) // if (!v)
test.isTrue(v, msg) // if(v)
test.equal(actual, expected, message)
test.notEqual(actual, expected, message)
test.length(obj, len, msg)
test.include(s, v) // s = string or object
test.isNaN(v, msg)
test.isUndefined(v, msg)
test.isNotNull(v, msg)
test.isNull(v, msg)

// expected can be:
//  undefined: accept any exception.
//  string: pass if the string is a substring of the exception message.
//  regexp: pass if the exception message passes the regexp.
//  function: call the function as a predicate with the exception.
test.throws(func, expected)

test.instanceOf(obj, klass)

test.runId() // Unique id for this test run

// Call this to fail the test with an exception. Use this to record
// exceptions that occur inside asynchronous callbacks in tests.
//
// It should only be used with asynchronous tests, and if you call
// this function, you should make sure that (1) the test doesn't
// call its callback (onComplete function); (2) the test function
// doesn't directly raise an exception.
test.exception(exception)

test.expect_fail()
```

## Travis CI integration

Create a `.travis.yml` file in your app repository with the following contents:

```yml
language: node_js
node_js:
- "0.10"
before_install:
- "curl -L https://install.meteor.com | /bin/sh"
- "meteor update"
- "wget https://raw.github.com/numtel/tinytest-in-app/master/.startTest.js"
- "wget https://raw.github.com/numtel/tinytest-in-app/master/.phantomRunner.js"
# Optionally, arguments can be added to Meteor startup
# ex: node .startTest.js --port 3500
script: "node .startTest.js"
```

## Command line interface
The Travis CI integration can be used to run Tinytest from your local command
line as well.

Add these two scripts to your application: (Dot files to prevent Meteor from
including them.)

```bash
$ wget https://raw.github.com/numtel/tinytest-in-app/master/.startTest.js
$ wget https://raw.github.com/numtel/tinytest-in-app/master/.phantomRunner.js
```

To run the tests from your application directory:

```bash
$ node .startTest.js

# Or specify any parameters to pass through when starting Meteor
$ node .startTest.js --port 3500
```

**Notes:**
* Use `nodejs` command on Debian, Ubuntu systems.
* Only one instance of Meteor may run at a time in a directory. If your app
  is running, you should use the in-browser interface instead.

## Related packages
* [numtel:tinytest-fixture-account](http://github.com/numtel/tinytest-fixture-account) - Create a fixture account for tests, remove when done
* [numtel:velocity-tinytest](https://github.com/numtel/velocity-tinytest) - Use Tinytest with Velocity in a Meteor app

## Run tests

```bash
$ git clone https://github.com/numtel/tinytest-in-app.git
$ cd tinytest-in-app
$ meteor test-packages ./
```

Open your browser to `http://localhost:3000/`

Open the Javascript console and run the following command:

```javascript
runTinytest()
```

Not all the tests are expected to pass. The tests must be manually verified by
checking the browser output against the console output.


## License

MIT
