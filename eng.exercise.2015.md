# It's all about stats!

Welcome to this first challenge. Its goal is to assert your ability to think critically, while being creative, and practical, when tackling real world problems. We value clean solutions *that work*, and thus the goal is not to determine your ability to use the latest and greatest buzzword, nor to evaluate your knowledge of esoteric meta-programming techniques.

This programming challenge is estimated to take approximately 2-3 hours of your time, if familiar with the various technologies (AngularJS, Rails, and Sequel). So, grab your favorite beverage and remember: keep it simple and stupid.

Should you have questions regarding this exercise, please contact Diogo Almeida at `dba@apple.com`, or your Apple Recruiter.

Good luck!

## Abstract
You have just joined a new team and they fill you in on the problem at hand: stats! The team is trying to come up with a prototype that will help determine their ability to produce an in-house web analysis platform that suits their specific business needs.

After some discussion about the scope of the prototype, and its goals, the team decides to task you with it.

## Goals
Your first goal is to come up with a Ruby on Rails application, using [Sequel](http://sequel.rubyforge.org) as its ORM, and that allows its users to access two distinct reports, in the realm of web stats, via a REST API:

1. number of page views per URL, grouped by day, for the past 5 days;

2. top 5 referrers for the top 10 URLs grouped by day, for the past 5 days.

Your prototype should only make use of Ruby and MySQL. Use of gems, e.g. Rails, JSON and MySQL2 is allowed. 

As a secondary goal, you will want to do a plain and simple UI, using AngularJS, that connects to the Rails application and presents the data that can be vended by one, or both, routes. You don't want to produce a super fancy UI, your goal is to get people an easy way to get to the data and produce an end-to-end (UI, Service, DB) prototype.

The produced source code can be delivered via a public [Github](http://github.com) repository, or email to [Diogo Almeida](mailto:dba@apple.com).

## The dataset
As you dig into this challenge, the first order of business is to come up with a *dummy* dataset, with exactly 1 million records, that you can use as a baseline for your endeavor. From the outset, you'll want to be able to regenerate this dataset at any given point in time, even if net result varies, and you will also want to store it in a MySQL table with the following structure:

| id (integer) | url (varchar)     | referrer (null varchar)   | created_at (datetime)     | hash (varchar)                   |
| :----------- | :---------------- | :------------------------ | :------------------------ | :------------------------------- |
| 1            | http://apple.com  | http://store.apple.com/us | 2012-01-01T00:00:00+00:00 | abe81c0456367aff8132c24d04718878 |
| 2            | https://apple.com | null                      | 2013-01-20T08:21:10+00:00 | f4a33acf2af3e2118038749588998512 |

### Dataset requirements
Please observe the following requirements when generating your dummy dataset:

#### id
A sequential integer that uniquely identifies the record.

#### url
The url (string) that an end-user visited on your website.

Your dataset should include these URLs at least once:
* http://apple.com
* https://apple.com
* https://www.apple.com
* http://developer.apple.com
* http://en.wikipedia.org
* http://opensource.org

#### referrer
The optional referrer url (string) that indicates the page the user came from.

Your dataset should include these referrers at least once:
* http://apple.com
* https://apple.com
* https://www.apple.com
* http://developer.apple.com
* `NULL`

#### created_at
Indicates the date and time at which the URL was visited by the user. Please note that your data should contain at least 10 distinct and sequential days.

#### hash
The MD5 hexdigest of a hash containing the aforementioned columns, modulo those whose value is null.

Example:
`Digest::MD5.hexdigest({id:1, url: 'http://apple.com', referrer: 'http://store.apple.com/us', created_at: Time.parse('2012-01-01')}.to_s)`

## The reports
Now that you have your dummy data you're ready to start tackling the two reports that the team has agreed to prototype.

### Report #1

The end-user should be able to access a REST endpoint in your application in order to retrieve the number of page views per URL, grouped by day, for the past 5 days.

Example request:

	[GET] /top_urls

Payload
> { '2012-01-01' : [ { 'url': 'http://apple.com', 'visits': 100 } ] }

### Report #2

Your end-users should be able to retrieve the top 5 referrers for the top 10 URLs grouped by day, for the past 5 days, via a REST endpoint.

Example request:

	[GET] /top_referrers

Payload
> {
>	'2012-01-01' : [
>		{
>			'url': 'http://apple.com',
>			'visits': 100,
>			'referrers': [ { 'url': 'http://store.apple.com/us', 'visits': 10 } ]
>		}
>	]
>}

## One more thing

We value tested code that performs well under heavy load.