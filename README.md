wiki-expert
===========

Recommender Engine for WikiMedia proof-of-concept system.

It uses Ruby lang and Mongo DB (it was 2013 😬)

It consists of:
 - batch jobs that prepare data index to be quickly looked up.
 - API server that uses the index and serves responses to JS frontend.
 - JS frontend standalone from wikipedia - for semantically exploring WikiMedia content
 - a JS plugin for WikiMedia PHP for looking up similar articles withim WikiMedia

The system was meant to handle security related topics so there is some security specifc code out there, especially on the frontend.

### Structure

##### Text Mining

For configuration there is a list of stop words that should be ommited when building search index.
The list is in `./lib/text-mining.rb`.

Polish language has also bunch of sufixes and conjugation that the `text-mining.rb` can take care of.
But it's very language specifc.

##### Lib

There is a Mongo DB index connector and WikiMedia MySQL connector inside `./lib` folder.

##### Jobs

jobs directory has all the code for batch processing jobs.

Rakefile - has description of all the possible tasks

##### API

The API server that uses the index prepared by batch processing jobs is inside `./apis` directory.

##### Frontend

Has a lot of poorly written polish language ridden code.

The frontend code is placed somewhere between `./frontend` and `./apis/public`

The WikiMedia JS plugin is present in `./apis/public/wiki-plugin.js` - ish

##### License

It's in the `LICENSE` file


