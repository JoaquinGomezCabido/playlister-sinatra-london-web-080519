class LibraryParser
  def files
    data_path = File.join(File.dirname(__FILE__), '..', 'db', 'data')
    Dir.entries(data_path)[2..-1]
  end

  def self.parse
    self.new.call
  end

  def parse_filename(filename)
    artist_match = filename.match(/^(.*) -/)
    song_match   = filename.match(/- (.*) \[/)
    genre_match  = filename.match(/\[([^\]]*)\]/)

    artist = artist_match && artist_match[1]
    song   = song_match   && song_match[1]
    genre  = genre_match  && genre_match[1]

    [artist, song, genre]
  end

  def call
    files.each do |filename|
      parts = parse_filename(filename)
      build_objects(*parts)
    end
  end

  def build_objects(artist_name, song_name, genre_name)
    artist = Artist.find_or_create_by(name: artist_name)
    song = Song.find_or_create_by(name: song_name, artist_id: artist.id) #####
    genre = Genre.find_or_create_by(name: genre_name)
    song_genre = SongGenre.find_or_create_by(song_id: song.id, genre_id: genre.id)  #####

    # song.song_genres.build(genre: genre)
    # song.artist = artist
    
    song.save
    artist.save
    genre.save
    song_genre.save
  end
end