# frozen_string_literal: true

DeviseTokenAuth.setup do |config|
  # 🔁 Mantém o cabeçalho Authorization constante entre requisições.
  # Útil para evitar que o frontend tenha que atualizar o token a cada request.
  config.change_headers_on_each_request = false

  # ⏰ Tempo de validade do token (ex: 2 semanas)
  config.token_lifespan = 2.weeks

  # 🔐 Custo do hash da senha (ajustado para testes e segurança em produção)
  config.token_cost = Rails.env.test? ? 4 : 10

  # 📱 Número máximo de dispositivos logados simultaneamente por usuário
  config.max_number_of_devices = 10

  # 🕒 Tempo de tolerância entre requisições em lote (ex: múltiplos requests paralelos)
  config.batch_request_buffer_throttle = 5.seconds

  # 📩 Requer senha atual ao atualizar informações de conta
  config.check_current_password_before_update = :attributes

  # 🔁 Callbacks padrão de Omniauth (pode manter se não usar OAuth)
  config.default_callbacks = true

  # 📨 Se você estiver usando `:confirmable`, ative isso para enviar e-mails de confirmação
  # config.send_confirmation_email = true
end
