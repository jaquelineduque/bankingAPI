# API bancária

A API bancária destina-se à disponibilizar métodos que simulam os métodos básicos necessários ao funcionário de um sistema bancário. Atualmente conta com as seguintes funcionalidades  
  - Criação e consulta de usuários
  - Login
  - Cadastro e de clientes
  - Criação e consulta de contas
  - Movimentações financeira como saque, depósito, transferência e débito.
  - Consulta de saldo
  - Consulta de extrato

### Tecnologias utilizadas 
 - Linguagem Exilir
 - Framework Phoenix

### Instalação
Passos para instalação descritos em "INSTALL.MD"[PENDENTE CRIAÇÃO].

### Métodos

 - GET /api/user
 - GET /api/user/:id
 - POST /api/user
 
### GET /api/user
Método destinado à consulta de usuários.  

>URL: http://localhost:4000/api/use
Onde, "localhost:4000" é o endereço onde seu WS estiver exposto.

Response em caso de sucesso:
```
{
    "users": [
        {
            "email": "xxxxxx",
            "id": 999,
            "is_active": false
        }
    ]
}
```
Onde, 
- **users**: Conjunto de usuários retornados na pesquisa.  
- **email**: E-mail cadastrado para o usuário. Formato: texto.  
- **id**: Id de cadastro do usuário. Formato: numérico.  
- **is_active**: Indicador se o usuário está ativo ou inativo. Formato: booleano (true/false).  

Response em caso de erro:
```
{
    "errors": {
        "code": 9999,
        "detail": "xxxxxx"
    }
}
```
Onde,   
- **errors**: Estrutura de erro retornado.
- **code**: Código interno do erro.
- **detail**: Mensagem detalhada do erro.

### GET /api/user/:id
Método destinado à consulta de usuário através do id de cadastro.  

>URL: http://localhost:4000/api/user/:id
Onde, "localhost:4000" é o endereço onde seu WS estiver exposto.

Response em caso de sucesso:
```
{
    "user": 
        {
            "email": "xxxxx",
            "id": 999,
            "is_active": false
        }
}
```
Onde, 
- **user**: Conjunto de informações do usuário retornado.  
- **email**: E-mail cadastrado para o usuário. Formato: texto.
- **id**: Id de cadastro do usuário. Formato: numérico.
- **is_active**: Indicador se o usuário está ativo ou inativo. Formato: booleano (true/false).

Response em caso de erro:
```
{
    "errors": {
        "code": 9999,
        "detail": "xxxxxx"
    }
}
```
Onde,   
- **errors**: Estrutura de erro retornado.
- **code**: Código interno do erro.
- **detail**: Mensagem detalhada do erro.

### POST /api/user
Método destinado ao cadastro de usuários.  

>URL: http://localhost:4000/api/use
Onde, "localhost:4000" é o endereço onde seu WS estiver exposto.

Request:
```
{
    "user": {
        "email": "xxxxxx",
        "password": "xxxxxx"
    }
}
```
Onde,  
- **email**: E-mail para cadastro. Formato: texto. Obrigatório.  
- **password**: Senha para cadastro. Formato: texto. Obrigatório.  

Response em caso de sucesso:
```
{
    "user": {
        "email": "xxxxxx",
        "id": 9999,
        "is_active": false
    }
}
```
Onde, 
- **user**: Conjunto de informações do usuário retornado.  
- **email**: E-mail cadastrado para o usuário. Formato: texto.  
- **id**: Id de cadastro do usuário. Formato: numérico.  
- **is_active**: Indicador se o usuário está ativo ou inativo. Formato: booleano (true/false).  
 
Response em caso de erro:
```
{
    "errors": {
        "code": 9999,
        "detail": "xxxxxx"
    }
}
```
Onde,   
- **errors**: Estrutura de erro retornado.
- **code**: Código interno do erro.
- **detail**: Mensagem detalhada do erro.
