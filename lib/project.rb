class Project
  attr_accessor :title, :id

  def initialize(attributes)
    @title = attributes.fetch(:title)
    @id = attributes.fetch(:id)

  end

  def save
    result = DB.exec("INSERT INTO books (title) VALUES ('#{@title}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def update(title)
    @title = title || @title
    DB.exec("UPDATE books SET title = '#{@title}' WHERE id = #{@id};")
  end

  def ==(book_to_compare)
    self.title() == book_to_compare.title()
  end

  def self.all
    self.get_books("SELECT * FROM books;")
  end

  def self.clear
    DB.exec("DELETE FROM books *;")
  end

  def self.find(id)
    book = DB.exec("SELECT * FROM books WHERE id = #{id};").first
    title = book.fetch("title")
    id = book.fetch("id").to_i
    Book.new({:title => title, :id => id})
  end

  def self.get_books(query)
    returned_books = DB.exec(query)
    books = []
    returned_books.each() do |book|
      title = book.fetch("title")
      id = book.fetch("id").to_i
      books.push(Book.new({:title => title, :id => id}))
    end
    books
  end

  def delete
    DB.exec("DELETE FROM books WHERE id = #{@id};")
  end

  def self.sort
    self.get_books("SELECT * FROM books ORDER BY lower(title);")
    # @books.values.sort {|a, b| a.name.downcase <=> b.name.downcase}
  end

  def self.search(x)
    self.get_books("SELECT * FROM books WHERE title ILIKE '%#{x}%'")
    # @books.values.select { |e| /#{x}/i.match? e.name}
  end
end
