Morpheus - the power of neo4j in easy Ruby library
==================================================

This gem gives you a way of using the REST API of neo4j graph database.

The main goals and differences to other libraries are:

- It doesn't try to mimic ActiveRecord or ORM library as the concepts are different.
- It forces you to think in terms of graph database, still preserving most of the conventions and semantics from Rails.
- It is compatible with ActiveModel and can be used in Rails 3 easily.
- Ruby DSL for node traversal and querying (with ability to fallback to raw API).
- Automatic batching whenever possible for optimal performance.
- Non-blocking operations.
- It is not just a wrapper over the REST API but rather comprehensive tool to leverage Ruby as much as possible.
- It can be used as standalone gem or as part of the Rails app.
- Allow to transparently reuse the code on either client or a server (via extensions mechanism)^.

Things with [*^*] may be a little too ambitious. But that's the whole point :)

Installation
==================================================

With Rails
--------------------------------------------------

1. Add `gem morpheus` to the `Gemfile` and `bundle install`.
2. Run the generator: `bundle exec rails g morpheus:install`.

Standalone
--------------------------------------------------

Just require the gem: `require 'morpheus'`.
Make sure it is installed in your system gems or with bundler.


Usage by Examples
==================================================

Simple standalone
--------------------------------------------------

```ruby
require 'morpheus'

class User < Morpheus::NodeBase
  # or if you don't want to inherit:
  # include Morpheus::Model::Node
end

db = Morpheus::Database.new.connect # Will use the default settings

me = User.new db, :name => 'Dmytrii', :email => 'dnagir@gmail.com'
db.users.save! me # This creates the graph: ROOT-users->me

me_again = db.users.first

me == me_again # => true
```

In the future examples I'll skip boilerplate code such as initiating `db`, requiring this gem etc.
Let me know if something isn't obvious from the context.

CRUD (can be used with Rails controllers)
--------------------------------------------------

```ruby
# Create:
# attach it to the path ROOT-users->User
db.users.save User.new db, :name => 'Dmytrii', :email => 'dnagir@gmail.com' # => true
# or if you want the node to exist in vacuum:
User.create db, :name => 'Dmytrii', :email => 'dnagir@gmail.com' # => true

# Read:
user = db.fetch User, 123 # instance of User

# Update:
user.twitter = '@dnagir'
user.save # true
#or
user.update_attributes :twitter => '@dnagir'

# Destroy:
user.destroy # true
```

Callbacks
--------------------------------------------------

```ruby
class User < Morpheus::NodeBase
  before_save :become_human
  before_save do
    email.upcase!
  end
  before_save :become_human,     :on => :create
  before_save :become_human,     :on => [:create, :udpate]
  before_validate :become_human

  def become_human
    # This will be called multiple times
    self.human = true
  end
end
```

Relationships - one-to-one
--------------------------------------------------

TBD

```ruby
class Person < Morpheus::NodeBase
  relates_to :address, :as => :workplace # specify `:name => :office` if accessor method is different from :workplace
end

class Address < Morpheus::NodeBase
end

# This assumes the graph: `Person<-workplace->Address` 

me = Person.new db
office = Address.new db

me.workplace = office
```



Relationships - one-to-many
--------------------------------------------------


```ruby
class Person < Morpheus::NodeBase
  relates_to_many :addresses, :as => :visited
end

class Address < Morpheus::NodeBase
end

# This assumes sub-graph `Person-visited->Address`

me = Person.new db
museum = Address.new db
park = Address.new db

me.visited << museum << park

```
Relationships - many-to-many
--------------------------------------------------

```ruby
class Person < Morpheus::NodeBase
  relates_to_many :addresses :as => :visited
end

class Address < Morpheus::NodeBase
  related_to_many :people, :as => :visited
end

# This assumes sub-graph `Person<-visited->Address`

he = Person.new db
she = Person.new db
museum = Address.new db
park = Address.new db

he.visited << museum << park
she.visited << museum

museum.visited # [he, she]
park.visited # [he]
```

Traversal
==================================================

The traversal API available uses pure Ruby syntax and chooses the best suitable query language automatically (is it a prophet or what?).

- Every method call (except `select` or similar internal methods) defines the traversing relationship.
- Every block near the method call defines a condition on the end-side node of the relationship.
- Every `where` clause applied defines a condition on a relationship.
- Query must end with: `select` call with a block of values returned.


Examples:

```ruby
# Find all users who are liked
db.query.users.likes.select


# All employees of the company with ID=123
db.query(123).employee.select

# All employees of the existing company object
company.query.employee.select



# All my friends that that have 'A' in the name and like somebody
me.query.friend{ name =~ /A/ }.likes.select { friend }

# All my friends and all of their friends and all of their friends with the friendship longer than 1 year
me.query.friend([1..2]).where(started >= 1.year_ago).select


# If everything fails, use Cypher
db.query(:cypher).map_to(User).select("START s=node(0) MATCH s-[:users]->()-[:likes]->u RETURN u")
```


Connection
--------------------------------------------------

TBD

Rake tasks
==================================================

TBD

Rails Generators
==================================================

TBD

- install
- model
- controller
- scaffold

Non-Blocking Operations
==================================================

By default all the requests will be dispatched asynchronously and the execution will not block.
This means that you can execute multiple independent request in parallel without any changes to your code.

If you will access a data that hasn't yet been fetched, the current thread will be blocked until the results will be returned.

This means that you can do the following:

```ruby
me = db.fetch User, 123
he = db.fetch User, 345

me.name
he.name
```

And the 2 requests will be executed in parallel (thus will take almost twice less time overall).
The execution will only block when you access any data (`me.name`) until the response will have been processed.


TBD: Exmplain how to configure



Additional Utilities
==================================================

TBD:

- FactoryGirl
- inherited_resources
- cancan
- Authlogic
- Auditor
- Automatic timestamps
- DatabaseCleaner

Alternatives
==================================================

- [neography](https://github.com/maxdemarzi/neography) - simple REST wrapper. Provides Node/Relationship classes for easy use. Well maintained.
- [neology](https://github.com/lordkada/neology) - wraps REST in models. Uses `neography` internally. Seems a bit forgotten and not maintained well (specs fail).
- [architect4r](https://github.com/namxam/architect4r) - ActiveRecord-like API with the only query language being Cypher. Not sure how well it's maintained (but specs fail).

