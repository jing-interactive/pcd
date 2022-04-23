// Movie.pde is disabled by default
// Rename Movie.pde_ to Movie.pde to enable it

import processing.video.*;

void stopMovie(Movie movie) {
    if (movie == null) return;

    if (movie.time() > 0.0) {
        // movie.stop();
        movie.jump(0);
        movie.pause();
    }
}

void drawMovie(Movie movie, float x, float y, float w, float h) {
    if (movie == null) return;

    // println("moviw.time(): " + movie.time());
    if (movie.available()) {
        movie.read();
    }
    if (movie.time() > 0.0) {
        image(movie, x, y, w, h);
    }
}

// full screen movie
void drawMovie(Movie movie) {
    drawMovie(movie, 0, 0, width, height);
}

HashMap<String, Movie> movies = new HashMap<String, Movie>();  // HashMap object

Movie getMovie(String filename) {
    Movie item = movies.get(filename);
    if (item == null) {
        item = new Movie(this, filename);
        movies.put(filename, item);
    }
    return item;
}
