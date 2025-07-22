import { createContext, useState, useEffect } from "react";

export const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [authTokens, setAuthTokens] = useState({
    "access-token": null,
    client: null,
    uid: null,
  });

  useEffect(() => {
    const storedUser = localStorage.getItem("user");
    const storedTokens = localStorage.getItem("authTokens");

    if (storedUser && storedTokens) {
      setUser(JSON.parse(storedUser));
      setAuthTokens(JSON.parse(storedTokens));
    }
  }, []);

  const login = (userData, tokens) => {
    setUser(userData);
    setAuthTokens(tokens);

    localStorage.setItem("user", JSON.stringify(userData));
    localStorage.setItem("authTokens", JSON.stringify(tokens));
  };

  const logout = () => {
    setUser(null);
    setAuthTokens({
      "access-token": null,
      client: null,
      uid: null,
    });

    localStorage.removeItem("user");
    localStorage.removeItem("authTokens");
  };

  return (
    <AuthContext.Provider value={{ user, authTokens, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
};
