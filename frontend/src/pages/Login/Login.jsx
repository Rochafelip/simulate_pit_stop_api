import { useContext, useState } from "react";
import { AuthContext } from "../../context/AuthContext";
import { useNavigate, Link } from "react-router-dom";
import api from "../../services/api";
import "./Login.css";

const Login = () => {
  const { login } = useContext(AuthContext);
  const navigate = useNavigate();

  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");

    try {
      const res = await api.post(
        "/auth/sign_in",
        { email, password },
        {
          headers: {
            "Content-Type": "application/json",
            Accept: "application/json",
          },
          withCredentials: true,
        }
      );

      const token = res.headers["access-token"];
      const client = res.headers["client"];
      const uid = res.headers["uid"];

      if (token && client && uid && res.data?.data) {
        const user = res.data.data;

        // Salvar todos os tokens juntos para reaproveitar no interceptor
        localStorage.setItem(
          "authTokens",
          JSON.stringify({
            "access-token": token,
            client,
            uid,
          })
        );

        // Atualiza o contexto com usuário e tokens
        login(user, { token, client, uid });

        console.log("✅ Login realizado com sucesso.");
        navigate("/home");
      } else {
        setError("Não foi possível autenticar. Verifique seus dados.");
        console.warn("Tokens ausentes ou resposta malformada:", res);
      }
    } catch (err) {
      const message =
        err.response?.data?.errors?.[0] ||
        err.response?.data?.error ||
        "Erro ao tentar logar. Verifique seus dados.";
      setError(message);
      console.error("Erro ao logar:", err);
    }
  };

  return (
    <div className="login-page d-flex justify-content-center align-items-center">
      <form className="login-form p-4 rounded" onSubmit={handleSubmit}>
        <h2 className="text-center mb-4">Bem-vindo ao RaceSim</h2>

        {error && <div className="alert alert-danger">{error}</div>}

        <div className="mb-3">
          <label htmlFor="email" className="form-label">Email</label>
          <input
            type="email"
            id="email"
            name="email"
            className="form-control input-metallic"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
        </div>

        <div className="mb-4">
          <label htmlFor="password" className="form-label">Senha</label>
          <input
            type="password"
            id="password"
            name="password"
            className="form-control input-metallic"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>

        <button type="submit" className="btn btn-primary w-100 mb-2">
          Entrar
        </button>

        <p className="text-center small text-gray">
          Não tem conta? <Link to="/register">Cadastre-se</Link>
        </p>
      </form>
    </div>
  );
};

export default Login;
