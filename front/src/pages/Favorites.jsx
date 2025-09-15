import MovieCard from "../components/MovieCard";

const Home =()=>{

    const movies = [
        {id:1,title:"movie1",release_date:"2020"},
        {id:2,title:"movie2",release_date:"2020"},
        {id:3,title:"movie3",release_date:"2020"},

    ]
    return(
        <div className="home">
            <div className="movies-grid">
                {
                    movies.map((movie)=> {
                        <MovieCard movie={movie} key={movie.id}/>

                    })
                }
            </div>

        </div>
    )

}
export default Home;