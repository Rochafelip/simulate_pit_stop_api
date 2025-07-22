import { useContext, useEffect } from "react";
import { AuthContext } from "../../context/AuthContext";
import { useNavigate } from "react-router-dom";
import "./Step1.css"; 

const Step1 = () => {
  const { user } = useContext(AuthContext);
  const navigate = useNavigate();

  useEffect(() => {
    
    if (!user) {
      navigate("/login");
    }
  }, [user, navigate]);

  if (!user) return null; 

  return (
    <div className="container mt-5">
      <h2>Bem-vindo ao Simulador, {user.name || user.email}!</h2>
      <p className="text-muted">Você está autenticado e chegou na etapa 1.</p>

      <div className="card mt-4">
        <div className="card-body">
          <h5 className="card-title">Seus dados</h5>
          <p className="card-text"><strong>Nome:</strong> {user.name || "Nome não disponível"}</p>
          <p className="card-text"><strong>Email:</strong> {user.email}</p>
        </div>
      </div>
    </div>
  );
};

export default Step1;
