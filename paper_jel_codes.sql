-- phpMyAdmin SQL Dump
-- version 4.5.5.1
-- http://www.phpmyadmin.net
--
-- Počítač: 127.0.0.1
-- Vytvořeno: Stř 14. pro 2016, 17:34
-- Verze serveru: 5.7.11
-- Verze PHP: 5.6.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Databáze: `emappefczu_db`
--

-- --------------------------------------------------------

--
-- Struktura tabulky `paper_jel_codes`
--

CREATE TABLE `paper_jel_codes` (
  `jel_code_id` bigint(20) NOT NULL,
  `paper_id` bigint(20) NOT NULL,
  `code` varchar(5) CHARACTER SET utf8 NOT NULL,
  `code_keyword` text CHARACTER SET utf8 NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Papers JEL Codes';

--
-- Klíče pro exportované tabulky
--

--
-- Klíče pro tabulku `paper_jel_codes`
--
ALTER TABLE `paper_jel_codes`
  ADD PRIMARY KEY (`jel_code_id`) USING BTREE,
  ADD KEY `paper_jel_codes_paper_id` (`paper_id`) USING BTREE;

--
-- AUTO_INCREMENT pro tabulky
--

--
-- AUTO_INCREMENT pro tabulku `paper_jel_codes`
--
ALTER TABLE `paper_jel_codes`
  MODIFY `jel_code_id` bigint(20) NOT NULL AUTO_INCREMENT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
