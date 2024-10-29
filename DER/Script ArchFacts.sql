DROP DATABASE ArchFacts;
CREATE DATABASE ArchFacts;
USE ArchFacts;


DROP TABLE IF EXISTS `Negocio`;

CREATE TABLE IF NOT EXISTS `Negocio` (
  `idNegocio` CHAR(36) NOT NULL,
  `nome` VARCHAR(125) NOT NULL,
  `codigo` VARCHAR(125) NOT NULL,
  `cep` CHAR(9) NOT NULL,
  `cpf` CHAR(11) NULL,
  `cnpj` CHAR(14) NULL,
  `dataRegistro` DATETIME NOT NULL,
  `avaliacao` INT(1) NULL,
  `ativado` tinyint(1) NOT NULL,
  PRIMARY KEY (`idNegocio`),
  UNIQUE INDEX `codigo_UNIQUE` (`codigo` ASC),
  UNIQUE INDEX `cep_UNIQUE` (`cep` ASC)
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table `Usuario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Usuario`;

CREATE TABLE IF NOT EXISTS `Usuario` (
  `idUsuario` CHAR(36) NOT NULL,
  `nome` VARCHAR(125) NOT NULL,
  `email` VARCHAR(125) NOT NULL,
  `senha` VARCHAR(125) NOT NULL,
  `telefone` CHAR(13) NOT NULL,
  `dataRegistro` DATETIME NOT NULL,
  `ativado` TINYINT NOT NULL,
  `role` VARCHAR(45) NOT NULL,
  `fkNegocio` CHAR(36),
  PRIMARY KEY (`idUsuario`),
  UNIQUE INDEX `telefone_UNIQUE` (`telefone` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  INDEX `fk_Usuario_Negocio_idx` (`fkNegocio` ASC),
  CONSTRAINT `fk_Usuario_Negocio`
    FOREIGN KEY (`fkNegocio`)
    REFERENCES `Negocio` (`idNegocio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table `Proposta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Proposta`;

CREATE TABLE IF NOT EXISTS `Proposta` (
  `idProposta` CHAR(36) NOT NULL,
  `conteudo` VARCHAR(250) NULL,
  `dataEnvio` DATETIME NULL,
  `fkRemetente` CHAR(36) NOT NULL,
  `fkDestinatario` CHAR(36) NOT NULL,
  PRIMARY KEY (`idProposta`),
  INDEX `fk_Proposta_Usuario1_idx` (`fkRemetente` ASC),
  INDEX `fk_Proposta_Negocio1_idx` (`fkDestinatario` ASC),
  CONSTRAINT `fk_Proposta_Usuario1`
    FOREIGN KEY (`fkRemetente`)
    REFERENCES `Usuario` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Proposta_Negocio1`
    FOREIGN KEY (`fkDestinatario`)
    REFERENCES `Negocio` (`idNegocio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table `Projeto`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Projeto`;

CREATE TABLE IF NOT EXISTS `Projeto` (
  `idProjeto` CHAR(36) NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `descricao` VARCHAR(250) NULL,
  `custo` VARCHAR(45) NOT NULL,
  `dataInicio` DATETIME NOT NULL,
  `dataEntrega` DATETIME NOT NULL,
  `status` VARCHAR(45) NOT NULL,
  `fkNegocio` CHAR(36) NOT NULL,
  PRIMARY KEY (`idProjeto`, `fkNegocio`),
  INDEX `fk_Projeto_Negocio1_idx` (`fkNegocio` ASC),
  CONSTRAINT `fk_Projeto_Negocio1`
    FOREIGN KEY (`fkNegocio`)
    REFERENCES `Negocio` (`idNegocio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

ALTER TABLE `Projeto`
ADD COLUMN `fkBeneficiario` CHAR(36) NOT NULL,
ADD CONSTRAINT `fk_Projeto_Usuario`
  FOREIGN KEY (`fkBeneficiario`)
  REFERENCES `Usuario` (`idUsuario`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

-- -----------------------------------------------------
-- Table `Financeiro`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Financeiro`;

CREATE TABLE IF NOT EXISTS `Financeiro` (
  `idFinanceiro` CHAR(36) NOT NULL,
  `lucroTotal` DOUBLE NOT NULL,
  `despesaTotal` DOUBLE NOT NULL,
  `Receita` DOUBLE NULL,
  `fkProjeto` CHAR(36) NOT NULL,
  PRIMARY KEY (`idFinanceiro`, `fkProjeto`),
  INDEX `fk_Financeiro_Projeto1_idx` (`fkProjeto` ASC),
  CONSTRAINT `fk_Financeiro_Projeto 1`
    FOREIGN KEY (`fkProjeto`)
    REFERENCES `Projeto` (`idProjeto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table `Chamado`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Chamado`;

CREATE TABLE IF NOT EXISTS `Chamado` (
  `idChamado` CHAR(36) NOT NULL,
  `titulo` VARCHAR(45) NOT NULL,
  `descricao` VARCHAR(250) NOT NULL,
  `abertura` DATETIME NOT NULL,
  `fechamento` DATETIME NULL,
  `status` VARCHAR(45) NOT NULL,
  `lucro` DOUBLE NOT NULL,
  `fkProjeto` CHAR(36) NOT NULL,
  PRIMARY KEY (`idChamado`, `fkProjeto`),
  INDEX `fk_Ticket_Projeto1_idx` (`fkProjeto` ASC),
  CONSTRAINT `fk_Ticket_Projeto1`
    FOREIGN KEY (`fkProjeto`)
    REFERENCES `Projeto` (`idProjeto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table `Tarefa`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Tarefa`;

CREATE TABLE IF NOT EXISTS `Tarefa` (
  `idTarefa` CHAR(36) NOT NULL,
  `titulo` VARCHAR(45) NOT NULL,
  `descricao` VARCHAR(250) NULL,
  `despesa` DOUBLE NULL,
  `dataInicio` DATETIME NULL,
  `dataTermino` DATETIME NULL,
  `prioridade` VARCHAR(45) NULL,
  `status` VARCHAR(45) NULL,
  `fkProjeto` CHAR(36) NOT NULL,
  PRIMARY KEY (`idTarefa`, `fkProjeto`),
  INDEX `fk_Tarefa_Projeto1_idx` (`fkProjeto` ASC),
  CONSTRAINT `fk_Tarefa_Projeto1`
    FOREIGN KEY (`fkProjeto`)
    REFERENCES `Projeto` (`idProjeto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table `Servico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Servico`;

CREATE TABLE IF NOT EXISTS `Servico` (
  `idServico` CHAR(36) NOT NULL,
  `nome` VARCHAR(45) NULL,
  `descricao` VARCHAR(250) NULL,
  `fkNegocio` CHAR(36) NOT NULL,
  PRIMARY KEY (`idServico`, `fkNegocio`),
  INDEX `fk_Servico_Negocio1_idx` (`fkNegocio` ASC),
  CONSTRAINT `fk_Servico_Negocio1`
    FOREIGN KEY (`fkNegocio`)
    REFERENCES `Negocio` (`idNegocio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table `Evento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Evento`;

CREATE TABLE IF NOT EXISTS `Evento` (
  `idEvento` CHAR(36) NOT NULL,
  `dataInicio` DATETIME NULL,
  `dataTermino` DATETIME NULL,
  `dataCriacao` DATETIME NULL,
  `tipo` VARCHAR(45) NULL,
  `descricao` VARCHAR(150) NULL,
  `status` VARCHAR(45) NULL,
  `fkProjeto` CHAR(36) NOT NULL,
  `fkNegocio` CHAR(36) NOT NULL,
  PRIMARY KEY (`idEvento`, `fkProjeto`, `fkNegocio`),
  INDEX `fk_Evento_Projeto1_idx` (`fkProjeto` ASC, `fkNegocio` ASC),
  CONSTRAINT `fk_Evento_Projeto1`
    FOREIGN KEY (`fkProjeto`, `fkNegocio`)
    REFERENCES `Projeto` (`idProjeto`, `fkNegocio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- -----------------------------------------------------
-- Table `Parcela`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Parcela`;

CREATE TABLE IF NOT EXISTS `Parcela` (
  `idParcela` CHAR(36) NOT NULL,
  `valor` DOUBLE NULL,
  `dataInicio` DATETIME NULL,
  `dataTermino` DATETIME NULL,
  `status` VARCHAR(45) NULL,
  `fkChamado` CHAR(36) NOT NULL,
  `fkProjeto` CHAR(36) NOT NULL,
  PRIMARY KEY (`idParcela`, `fkChamado`, `fkProjeto`),
  INDEX `fk_Parcela_Chamado1_idx` (`fkChamado` ASC, `fkProjeto` ASC),
  CONSTRAINT `fk_Parcela_Chamado1`
    FOREIGN KEY (`fkChamado`, `fkProjeto`)
    REFERENCES `Chamado` (`idChamado`, `fkProjeto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

drop table if exists `Endereco`;

CREATE TABLE if not exists `Endereco` (
    id CHAR(36) PRIMARY KEY,
    cep VARCHAR(9),
    estado VARCHAR(2),
    bairro VARCHAR(50),
    cidade VARCHAR(50),
    rua VARCHAR(100),
    numero INT,
    fkNegocio CHAR(36),
    CONSTRAINT fk_negocio FOREIGN KEY (fkNegocio) REFERENCES negocio(idNegocio)
);

INSERT INTO `Negocio` (`idNegocio`, `nome`, `codigo`, `cep`, `cpf`, `cnpj`, `dataRegistro`, `avaliacao`, `ativado`
) VALUES (
  'f47ac10b-58cc-4372-a567-0e02b2c3d479',  
  'Negócio Exemplo',                        
  'codigo123',                              
  '12345-678',                              
  null,                            
  '12345678000195',                         
  NOW(),                                   
  NULL,                                     
  1                                 
);

INSERT INTO `Usuario` (`idUsuario`, `nome`, `email`, `senha`, `telefone`, `dataRegistro`, `ativado`, `role`, `fkNegocio`
) VALUES (
  'dca3d1f4-81e7-4cf1-a1cb-75f87c2920b6',  
  'usuario@example.com',                    
  'usuario@example.com',                    
  'senhaSegura123',                         
  '11987654321',                           
  NOW(),                                   
  1,                                        
  'ADM',                                   
  'f47ac10b-58cc-4372-a567-0e02b2c3d479'   
);

select * from projeto;
select * from evento;
select * from usuario;
