import "./Home.css";

const Home = () => {
  return (
    <div className="landing-container">
      <h1 className="main-title animated-gradient">Welcome to Your AWS Deployement!</h1>
      <p className="subtitle fade-in">
        Just a beautiful React landing page for AWS deployment using S3 and Cloud front , CI/CD and terraform.
      </p>
      <div className="cta-section">
        <button className="glow-btn" onClick={() => alert("Thanks for visiting!")}>
          Get Started
        </button>
      </div>
    </div>
  );
};



export default Home;

