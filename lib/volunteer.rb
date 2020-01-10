class Volunteer
  attr_reader :id
  attr_accessor :name

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def save
    result = DB.exec("INSERT INTO authors (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  # def update(name)
  #   @name = name
  #   DB.exec("UPDATE authors SET name = '#{@name}' WHERE id = #{@id};")
  # end

  def ==(author_to_compare)
    self.name() == author_to_compare.name()
  end

  def self.all
    self.get_authors("SELECT * FROM authors;")
  end

  def self.clear
    DB.exec("DELETE FROM authors *;")
  end

  def self.sort
    self.get_authors("SELECT * FROM authors ORDER BY lower(name);")
    # @books.values.sort {|a, b| a.name.downcase <=> b.name.downcase}
  end

  # def update(attributes)
  #   if (attributes.is_a? String)
  #     @name = attributes
  #     DB.exec("UPDATE authors SET name = '#{@name}' WHERE id = #{@id};")
  #   else
  #     book_name = attributes.fetch(:book_name)
  #     if book_name != nil
  #       book = DB.exec("SELECT * FROM books WHERE lower(title)='#{book_name.downcase}';").first
  #       if book != nil
  #         DB.exec("INSERT INTO authors_books (books_id, authors_id) VALUES (#{book['id'].to_i}, #{@id});")
  #       end
  #     end
  #   end
  # end

  def update(attributes)
    if (attributes.is_a? String)
      @name = attributes
      DB.exec("UPDATE authors SET name = '#{@name}' WHERE id = #{@id};")
    else
      book_name = attributes.fetch(:book_name)
      if book_name != nil
        book = DB.exec("SELECT * FROM books WHERE lower(title)='#{book_name.downcase}';").first
        if book != nil
          DB.exec("INSERT INTO authors_books (books_id, authors_id) VALUES (#{book['id'].to_i}, #{@id});")
        end
      end
    end
  end

  def self.find(id)
    author = DB.exec("SELECT * FROM authors WHERE id = #{id};").first
    name = author.fetch("name")
    id = author.fetch("id").to_i
    Author.new({:name => name, :id => id})
  end

  def delete
    DB.exec("DELETE FROM authors_books WHERE authors_id = #{@id};")
    DB.exec("DELETE FROM authors WHERE id = #{@id};")
  end

  def books
  books = []
  results = DB.exec("SELECT books_id FROM authors_books WHERE authors_id = #{@id};")
    results.each() do |result|
      books_id = result.fetch("books_id").to_i()
      book = DB.exec("SELECT * FROM books WHERE id = #{books_id};")
binding.pry
      title = book.fetch("title")
      books.push(Book.new({:title => title, :id => books_id}))
    end
    books
  end
    # id_string = results.first.fetch("books_id").to_i()
    # (id_string != '') ? Book.get_books("SELECT * FROM books where ID in (#{id_string});") : []



  # results.each() do |result|
  #   book_id = result.fetch("book_id").to_i()
  #   book = DB.exec("SELECT * FROM books WHERE id = #{book_id};").first()
  #   name = book.fetch("name").join(', ')
  #   release_year = book.fetch("release_year")
  #   genre = book.fetch("genre")
  #   author = book.fetch("author")
  #   books.push(Album.new({:name => name, :id => book_id, :release_year => release_year, :genre => genre, :author => author}))
  # end
  # books


def self.get_authors(query)
  returned_authors = DB.exec(query)
  authors = []
  returned_authors.each() do |author|
    name = author.fetch("name")
    id = author.fetch("id").to_i
    authors.push(Author.new({:name => name, :id => id}))
  end
  authors
end

def self.search(x)
  self.get_authors("SELECT * FROM authors WHERE name ILIKE '%#{x}%'")
  # @books.values.select { |e| /#{x}/i.match? e.name}
end

end
