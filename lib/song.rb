class Song
  @@all = []
  attr_accessor :name
  attr_reader :artist, :genre

  def initialize(name, artist=nil, genre=nil)
    @name = name
    self.artist=(artist)
    self.genre=(genre)
  end

  def self.new_from_filename(filename)
    elements = filename.gsub(/.mp3/,'').split(' - ')
    artist = Artist.find_or_create_by_name(elements[0])
    genre = Genre.find_or_create_by_name(elements[2])
    song = Song.new(elements[1], artist, genre)
  end

  def self.create_from_filename(filename)
    self.new_from_filename(filename).save
  end

  def self.find_by_name(name)
    self.all.find {|song| song.name == name}
  end

  def self.find_or_create_by_name(name)
    song = self.find_by_name(name)
    song = self.create(name) if song.nil?
    song
  end

  def genre=(genre)
    @genre = genre
    genre.songs << self if !genre.nil? and !genre.songs.include?(self)
  end

  def artist=(artist)
    @artist = artist
    artist.add_song(self) if !artist.nil?
  end

  def self.create(name)
    new_song = Song.new(name)
    new_song.save
    new_song
  end

  def self.destroy_all
    self.all.clear
  end

  def self.all
    @@all
  end

  def save
    self.class.all << self
  end
end
