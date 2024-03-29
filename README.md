# API bancária

A API bancária destina-se à disponibilizar métodos que simulam os métodos básicos necessários ao funcionário de um sistema bancário. Atualmente conta com as seguintes funcionalidades  
  - Criação e consulta de usuários
  - Login
  - Cadastro e de clientes
  - Criação e consulta de contas
  - Movimentações financeiras como saque, depósito, transferência e débito.
  - Consulta de saldo
  - Consulta de extrato  

### Tecnologias utilizadas 
 - Linguagem Exilir
 - Framework Phoenix
 - PostgreSQL

### Instalação
Passos para deploy descritos em "DEPLOY.MD".

### Sobre a autenticação  
Com exceção da criação de usuário e login, por segurança, os demais métodos necessitam de autenticação. Para esta API está sendo utilizado o _**Bearer Token**_, portanto ele deverá ser enviado na autenticação das chamadas nas quais for obrigatório.  
Caso esteja utilizando o Postman para seus testes,um tutorial de como enviar estas autorizações consta na página do [Postman](https://learning.getpostman.com/docs/postman/sending-api-requests/authorization/).

### Métodos

 - POST /api/user
 - POST /api/user/login
 - GET /api/user
 - GET /api/user/:id
 - POST /api/client
 - GET /api/client
 - GET /api/client/:id
 - POST /api/account
 - GET /api/account
 - GET /api/account/:id
 - POST /api/account/activate/:id
 - POST /api/financial/withdraw
 - POST /api/financial/deposit
 - POST /api/financial/debit
 - POST /api/financial/transfer
 - GET /api/financial/balance
 - GET /api/financial/statement
 

### POST /api/user
Método destinado ao cadastro de usuários.  

>URL: https://banking.gigalixirapp.com/api/user  


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

### POST /api/user/login
Método destinado ao login de usuários. Se houver sucesso, retorna um token que deverá ser utilizado nas demais operações.  

>URL: https://banking.gigalixirapp.com/api/user/login  


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
- **email**: E-mail de cadastro do usuário.
- **senha**: Senha de cadastro do usuário.


Response em caso do sucesso:
```
{
    "user": {
        "id": 9999,
        "token": "xxxxxx"
    }
}
```

Onde,  
- **user**: Estrutura com dados do usuário.
- **id**: Id do usuário.
- **token**: Token de acesso para as demais operações.

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

### GET /api/user
Método destinado à consulta de usuários.  

>URL: https://banking.gigalixirapp.com/api/user  


**O token enviando no login deverá ser utilizado na autorização desta requisição.**  
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

>URL: https://banking.gigalixirapp.com/api/user/:id  
Onde,  
":id" é o id do usuário que está sendo consultado

**O token enviando no login deverá ser utilizado na autorização desta requisição.**
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

### POST /api/client
Método destinado ao cadastro do cliente.  

>URL: https://banking.gigalixirapp.com/api/client  


**O token enviando no login deverá ser utilizado na autorização desta requisição.**  
Request:
```
{
    "client_register": {
        "user_id": 9999,
        "name":"xxxxxx",
        "cpf": "99999999999",
        "date_of_birth": "AAAA-MM-DD"
    }
}
```

Onde,  
- **client_register**: Estrutura para os dados do cliente.
- **user_id**: Id do usuário que está sendo cadastrado. Este dado é obtido após a criação de usuário (onde são definidos email e senha).
- **name**: Nome do cliente. Formato: texto. Obrigatório.
- **cpf**: CPF do cliente. Formato: texto. Obrigatório. Observaçao: enviar sem pontuação.
- **date_of_birth**: Data de nascimento do cliente. Formato: data (AAAA-MM-DD).

Response em caso de sucesso:
```
{
    "client_register": {
        "cpf": "99999999999",
        "date_of_birth": "AAAA-MM-DD",
        "id": 9999,
        "name": "xxxxxx",
        "user_id": 9999
    }
}
```

Onde,  
- **client_register**: Estrutura para os dados do cliente.
- **cpf**: CPF do cliente. Formato: texto. Obrigatório. Observaçao: enviar sem pontuação.
- **date_of_birth**: Data de nascimento do cliente. Formato: data (AAAA-MM-DD).
- **id**: Id do registro de cadastro.
- **name**: Nome do cliente. Formato: texto. Obrigatório.
- **user_id**: Id do usuário atrelado ao cadastro.

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

### GET /api/client
Método destinado à consulta de cliente.  

>URL: https://banking.gigalixirapp.com/api/client  


**O token enviando no login deverá ser utilizado na autorização desta requisição.**  

Response em caso de sucesso:
```
{
    "client_registers": [
        {
            "cpf": "99999999999",
            "date_of_birth": "AAAA-MM-DD",
            "id": 9999,
            "name": "xxxxxx",
            "user_id": 99999
        }
    ]
}
```

Onde,  
- **client_registers**: Estrutura para os dados dos clientes.
- **cpf**: CPF do cliente. Formato: texto. Obrigatório. Observaçao: enviar sem pontuação.
- **date_of_birth**: Data de nascimento do cliente. Formato: data (AAAA-MM-DD).
- **id**: Id do registro de cadastro.
- **name**: Nome do cliente. Formato: texto. Obrigatório.
- **user_id**: Id do usuário atrelado ao cadastro.

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

### GET /api/client/:id
Método destinado à consulta de cliente através do id.  

>URL: https://banking.gigalixirapp.com/api/client/:id  
Onde,  
":id" é o id do cadastro a ser consultado.

**O token enviando no login deverá ser utilizado na autorização desta requisição.**  

Response em caso de sucesso:
```
{
    "client_register": 
        {
            "cpf": "99999999999",
            "date_of_birth": "AAAA-MM-DD",
            "id": 9999,
            "name": "xxxxxx",
            "user_id": 99999
        }
}
```

Onde,  
- **client_register**: Estrutura para os dados do cliente.
- **cpf**: CPF do cliente. Formato: texto. Obrigatório. Observaçao: enviar sem pontuação.
- **date_of_birth**: Data de nascimento do cliente. Formato: data (AAAA-MM-DD).
- **id**: Id do registro de cadastro.
- **name**: Nome do cliente. Formato: texto. Obrigatório.
- **user_id**: Id do usuário atrelado ao cadastro.

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
 

### POST /api/account
Método destinado à criação de contas.  

>URL: https://banking.gigalixirapp.com/api/account  


**O token enviando no login deverá ser utilizado na autorização desta requisição.**  
Request:
```
{
    "account_register": {
        "user_id": 9
    }
}
```
Onde,  
- **account_register**: Estrutura para os dados de conta.
- **user_id**: Id do usuário para o qual a conta está sendo criada. Formato: numérico. Obrigatório.

Response em caso de sucesso:
```
{
    "account": {
        "account_number": "99999999",
        "active": false,
        "agency_number": "9999",
        "id": 9999,
        "opening_date": AAAA-MM-DD
    }
}
```
Onde,  
- **account**: Estrutura para os dados de conta.
- **account_number**: Número da conta. Formato: texto.
- **active**: Informa se a conta está ativa ou inativa. Formato: booleano (true/false). A conta precisa ser ativada por um método apartado.
- **agency_number**: Número da agência. Formato: texto.
- **id**: Id da conta. Formato: numérico.
- **opening_date**: Data de abertura da conta, contada a partir da sua ativação. Formato: data (AAAA-MM-DDD).

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

### GET /api/account
Método destinado à consulta de contas.  

>URL: https://banking.gigalixirapp.com/api/account  


**O token enviando no login deverá ser utilizado na autorização desta requisição.** 

Response em caso de sucesso:
```
{
    "accounts": [
        {
            "account_number": "99999999",
            "active": false,
            "agency_number": "9999",
            "id": 9999,
            "opening_date": "AAAA-MM-DD"
        }
    ]
}
```
Onde,  
- **account**: Estrutura para os dados de conta.
- **account_number**: Número da conta. Formato: texto.
- **active**: Informa se a conta está ativa ou inativa. Formato: booleano (true/false). A conta precisa ser ativada por um método apartado.
- **agency_number**: Número da agência. Formato: texto.
- **id**: Id da conta. Formato: numérico.
- **opening_date**: Data de abertura da conta, contada a partir da sua ativação. Formato: data (AAAA-MM-DDD).

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

### GET /api/account/:id
Método destinado à consulta de conta através do id.  

>URL: https://banking.gigalixirapp.com/api/account  
Onde,  
":id" é o id da conta à ser consultada.

**O token enviando no login deverá ser utilizado na autorização desta requisição.** 

Response em caso de sucesso:
```
{
    "accounts": {
        "account_number": "99999999",
        "active": false,
        "agency_number": "9999",
        "id": 9999,
        "opening_date": "AAAA-MM-DD"
    }
}
```
Onde,  
- **account**: Estrutura para os dados de conta.
- **account_number**: Número da conta. Formato: texto.
- **active**: Informa se a conta está ativa ou inativa. Formato: booleano (true/false). A conta precisa ser ativada por um método apartado.
- **agency_number**: NúmOnde,  
- **account**: Estrutura para os dados de conta.
- **account_number**: Número da conta. Formato: texto.
- **active**: Informa se a conta está ativa ou inativa. Formato: booleano (true/false). A conta precisa ser ativada por um método apartado.
- **agency_number**: Número da agência. Formato: texto.
- **id**: Id da conta. Formato: numérico.
- **opening_date**: Data de abertura da conta, contada a partir da sua ativação. Formato: data (AAAA-MM-DDD).ero da agência. Formato: texto.
- **id**: Id da conta. Formato: numérico.
- **opening_date**: Data de abertura da conta, contada a partir da sua ativação. Formato: data (AAAA-MM-DDD).

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

### POST /api/account/activate/:id
Método destinado à ativação de conta através do id.  

>URL: https://banking.gigalixirapp.com/api/account/activate/:id  
Onde,  
":id" é o id da conta à ser consultada.

**O token enviando no login deverá ser utilizado na autorização desta requisição.** 

Response em caso de sucesso:
```
{
    "account": {
        "account_number": "99999999",
        "active": true,
        "agency_number": "9999",
        "id": 9999,
        "opening_date": "AAAA-MM-DD"
    }
}
```
Onde,  
- **account**: Estrutura para os dados de conta.
- **account_number**: Número da conta. Formato: texto.
- **active**: Informa se a conta está ativa ou inativa. Formato: booleano (true/false). Quando há sucesso na ativação, o dado virá como true.
- **agency_number**: Número da agência. Formato: texto.
- **id**: Id da conta. Formato: numérico.
- **opening_date**: Data de abertura da conta, quando há sucesso neste processo de ativação é apresentada a data atual. Formato: data (AAAA-MM-DDD).

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

### POST /api/financial/withdraw
Método destinado ao saque em conta.  

>URL: https://banking.gigalixirapp.com/api/financial/withdraw  


**O token enviando no login deverá ser utilizado na autorização desta requisição.** 

Request:
```
{
    "financial_moviment": {
        "account_register_id": 9999,
        "moviment_amount": 99.99,
        "moviment_description": "xxxxxx"
    }
}
```

Onde,  
- **financial_moviment**: Estrutura com os dados da movimentação.
- **account_register_id**: Id  da conta. Formato: numérico. Obrigatório.
- **moviment_amount**: Valor da movimentação. Formato: numérico decimal. Separador decimal: "." (Exemplo: 99.99). Obrigatório.
- **moviment_description**: Descrição da movimentação. Formato: texto.

Response em caso de sucesso:

```
{
    "financial_moviment": {
        "id": 9999,
        "moviment_amount": "99.99",
        "moviment_date": "AAAA-MM-DDTHH:MM:SS.ZZZZZZZ",
        "moviment_description": "Saque em agência"
    }
}
```
Onde,  
- **id**: Id da movimentação. Formato: numérico.
- **moviment_amount**: Valor da movimentação. Formato: texto.
- **moviment_date**: Data e hora da movimentação. Formato: data e hora (AAAA-MM-DDTHH:MM:SS.ZZZZZZZ). **As datas/hora são em UTC (Coordinated Universal Time)**.
- **moviment_description**: Descrição do movimento. Formato: texto.

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

### POST /api/financial/deposit
Método destinado ao depósito em conta.  

>URL: https://banking.gigalixirapp.com/api/financial/deposit  


**O token enviando no login deverá ser utilizado na autorização desta requisição.** 

Request:
```
{
    "financial_moviment": {
        "account_register_id": 9999,
        "moviment_amount": 99.99,
        "moviment_description": "xxxxxx"
    }
}
```

Onde,  
- **financial_moviment**: Estrutura com os dados da movimentação.
- **account_register_id**: Id  da conta. Formato: numérico. Obrigatório.
- **moviment_amount**: Valor da movimentação. Formato: numérico decimal. Separador decimal: "." (Exemplo: 99.99). Obrigatório.
- **moviment_description**: Descrição da movimentação. Formato: texto.

Response em caso de sucesso:

```
{
    "financial_moviment": {
        "id": 9999,
        "moviment_amount": "99.99",
        "moviment_date": "AAAA-MM-DDTHH:MM:SS.ZZZZZZZ",
        "moviment_description": "Saque em agência"
    }
}
```
Onde,  
- **id**: Id da movimentação. Formato: numérico.
- **moviment_amount**: Valor da movimentação. Formato: texto.
- **moviment_date**: Data e hora da movimentação. Formato: data e hora (AAAA-MM-DDTHH:MM:SS.ZZZZZZZ). **As datas/hora são em UTC (Coordinated Universal Time)**.
- **moviment_description**: Descrição do movimento. Formato: texto.

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

### POST /api/financial/debit
Método destinado ao débito em conta.  

>URL: https://banking.gigalixirapp.com/api/financial/debit  


**O token enviando no login deverá ser utilizado na autorização desta requisição.** 

Request:
```
{
    "financial_moviment": {
        "account_register_id": 9999,
        "moviment_amount": 99.99,
        "moviment_description": "xxxxxx"
    }
}
```

Onde,  
- **financial_moviment**: Estrutura com os dados da movimentação.
- **account_register_id**: Id  da conta. Formato: numérico. Obrigatório.
- **moviment_amount**: Valor da movimentação. Formato: numérico decimal. Separador decimal: "." (Exemplo: 99.99). Obrigatório.
- **moviment_description**: Descrição da movimentação. Formato: texto.

Response em caso de sucesso:

```
{
    "financial_moviment": {
        "id": 9999,
        "moviment_amount": "99.99",
        "moviment_date": "AAAA-MM-DDTHH:MM:SS.ZZZZZZZ",
        "moviment_description": "Saque em agência"
    }
}
```
Onde,  
- **id**: Id da movimentação. Formato: numérico.
- **moviment_amount**: Valor da movimentação. Formato: texto.
- **moviment_date**: Data e hora da movimentação. Formato: data e hora (AAAA-MM-DDTHH:MM:SS.ZZZZZZZ). **As datas/hora são em UTC (Coordinated Universal Time)**.
- **moviment_description**: Descrição do movimento. Formato: texto.

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

### POST /api/financial/transfer
Método destinado às transferências entre contas.  

>URL: https://banking.gigalixirapp.com/api/financial/transfer  


**O token enviando no login deverá ser utilizado na autorização desta requisição.** 

Request:
```
{
    "transfer_moviment":{
        "account_register_id_origin": 9999,
        "account_register_id_destiny": 9999,
        "moviment_amount": 99.99
    }
}
```

Onde,  
- **account_register_id_origin**: Id da conta de origem (da qual o valor será debitado). Formato: numérico. Obrigatório.
- **account_register_id_destiny**: Id da conta de destino (na qual o valor será creditado). Formato: numérico. Obrigatório
- **moviment_amount**: Valor da movimentação. Formato: numérico decimal. Separador decimal: "." (99.99). Obrigatório.

Response em caso de sucesso:
```
{
    "transfer_moviment": {
        "id": 9999,
        "moviment_amount": "99.99"
    }
}
```
Onde,  
- **transfer_moviment**: Estrutura para os dados de transferência.
- **id**: Id da transferência. Formato: numérico.
- **moviment_amount**: Valor da movimentação. Formato: numérico decimal. Separador decimal: "." (99.99).

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

### GET /api/financial/balance
Método destinado à consulta de saldo.  

>URL: https://banking.gigalixirapp.com/api/financial/balance?account_register_id=999  
Onde,    
"account_register_id" é o id da conta

**O token enviando no login deverá ser utilizado na autorização desta requisição.** 

Response em caso de sucesso:
```
{
    "account_balance": {
        "account_register_id": 9999,
        "balance_amount": "99.99"
    }
}
```
Onde,
- **account_balance**: Estrutura com os dados do saldo.
- **account_register_id**: Id da conta. Formato: numérico.
- **balance_amount**: Saldo em conta no momento da consulta. Formato: Formato: numérico decimal. Separador decimal: "." (99.99).

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

### GET /api/financial/statement
Método destinado à consulta de extrato.  

>URL: https://banking.gigalixirapp.com/api/financial/statement?account_register_id=9999&starting_date=AAAA-MM-DD&ending_date=AAAA-MM-DD  
Onde,  
"account_register_id" é o id da conta
"starting_date" é a data de início da busca. Formato: data (AAAA-MM-DD)
"ending_date" é a data de fim da busca. Formato: data (AAAA-MM-DD)

**O token enviando no login deverá ser utilizado na autorização desta requisição.** 

Response em caso de sucesso:
```
{
    "financial_moviments": [
        {
            "id": 9999,
            "moviment_amount": "99.99",
            "moviment_date": "AAAA-MM-DDTHH:MM:SS.ZZZZZZZ",
            "moviment_description": "xxxxxx"
        }
    ]
}
```
Onde,  
- **financial_moviments**: Estrutura com as movimentações dentro da datas consultadas.
- **id**: Id da movimentação.
- **moviment_amount**: Valor da movimentação. Formato: numérico decimal. Separador decimal: "." (99.99).
- **moviment_date**: ata e hora da movimentação. Formato: data e hora (AAAA-MM-DDTHH:MM:SS.ZZZZZZZ). **As datas/hora são em UTC (Coordinated Universal Time)**.
- **moviment_description**: Descrição da movimentação. Formato: texto.

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

