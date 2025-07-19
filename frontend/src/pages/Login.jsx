import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

const Login = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const navigate = useNavigate();

  const handleLogin = async (e) => {
    e.preventDefault();
    try {
      const response = await axios.post('http://localhost:3000/auth/sign_in', {
        email,
        password,
      });

      const tokenData = {
        'access-token': response.headers['access-token'],
        client: response.headers['client'],
        uid: response.headers['uid'],
      };

      localStorage.setItem('authHeaders', JSON.stringify(tokenData));

      navigate('/dashboard');
    } catch (error) {
      console.error('Erro no login:', error);
      alert('Login inválido!');
    }
  };

  return (
    <form onSubmit={handleLogin}>
      <h2>Login</h2>
      <input
        type="email"
        placeholder="E-mail"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        required
      />
      <br />
      <input
        type="password"
        placeholder="Senha"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        required
      />
      <br />
      <button type="submit">Entrar</button>
    </form>
  );
};

export default Login;
