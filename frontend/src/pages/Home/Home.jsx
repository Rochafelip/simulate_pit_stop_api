import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import api from "../../services/api";
import "./Home.css";

const Home = () => {
  const navigate = useNavigate();

  const [cars, setCars] = useState([]);
  const [races, setRaces] = useState([]);
  const [tracks, setTracks] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const carsRes = await api.get("/cars");
        setCars(carsRes.data);

        const racesRes = await api.get("/races");
        setRaces(racesRes.data);

        const tracksRes = await api.get("/tracks");
        setTracks(tracksRes.data);
      } catch (err) {
        console.error("Erro ao carregar dados:", err);
      }
    };

    fetchData();
  }, []);

  return (
    <div className="container py-4">
      <h2 className="mb-4 text-center">🏁 Dashboard do RaceSim</h2>

      <div className="d-flex justify-content-center flex-wrap gap-3 mb-5">
        <button className="btn btn-outline-primary" onClick={() => navigate("/cars/new")}>
          🚗 Adicionar Carro
        </button>
        <button className="btn btn-outline-success" onClick={() => navigate("/tracks/new")}>
          🏟️ Adicionar Pista
        </button>
        <button className="btn btn-outline-warning" onClick={() => navigate("/races/new")}>
          🏁 Criar Corrida
        </button>
      </div>

      <div className="row">
        <div className="col-md-4 mb-4">
          <h5>🚗 Meus Carros</h5>
          <ul className="list-group">
            {cars.map((car) => (
              <li key={car.id} className="list-group-item">
                {car.name || `Carro #${car.id}`}
              </li>
            ))}
            {cars.length === 0 && <li className="list-group-item">Nenhum carro cadastrado.</li>}
          </ul>
        </div>

        <div className="col-md-4 mb-4">
          <h5>🏟️ Minhas Pistas</h5>
          <ul className="list-group">
            {tracks.map((track) => (
              <li key={track.id} className="list-group-item">
                {track.name || `Pista #${track.id}`}
              </li>
            ))}
            {tracks.length === 0 && <li className="list-group-item">Nenhuma pista cadastrada.</li>}
          </ul>
        </div>

        <div className="col-md-4 mb-4">
          <h5>🏆 Corridas</h5>
          <ul className="list-group">
            {races.map((race) => (
              <li key={race.id} className="list-group-item">
                {race.name || `Corrida #${race.id}`}
              </li>
            ))}
            {races.length === 0 && <li className="list-group-item">Nenhuma corrida realizada ainda.</li>}
          </ul>
        </div>
      </div>
    </div>
  );
};

export default Home;
