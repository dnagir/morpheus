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


Using
==================================================

Standalone
--------------------------------------------------


Examples
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

CRUD
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

Connection
--------------------------------------------------

TBD

Rake tasks
==================================================

TBD

Rails Generators
==================================================

TBD

Non-Blocking Operations
==================================================

TBD

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

