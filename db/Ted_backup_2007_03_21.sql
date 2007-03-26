-- MySQL dump 10.10
--
-- Host: localhost    Database: biorails_development
-- ------------------------------------------------------
-- Server version	5.0.24a-Debian_9-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
CREATE TABLE `audit_logs` (
  `id` int(11) NOT NULL auto_increment,
  `auditable_id` int(11) default NULL,
  `auditable_type` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `action` varchar(255) default NULL,
  `changes` text,
  `created_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `audit_logs`
--


/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES (1,107,'Task',2,'update','--- \nprocess_instance_id: \n- 98\n- \n',NULL,'2006-12-18 12:40:46'),(2,107,'Task',2,'update','--- \nend_date: \n- 2006-12-19 12:28:26 +00:00\n- 2006-12-18 00:00:00 +00:00\nstart_date: \n- 2006-12-18 12:28:26 +00:00\n- 2006-12-18 00:00:00 +00:00\nassigned_to: \n- \n- thawkins\ndescription: \n- This task is linked to external cvs file for import created called BPWM001-BPWM001:4.csv\n- \"\"\nstatus_id: \n- \n- \"1\"\nis_milestone: \n- \n- false\n',NULL,'2006-12-18 12:44:50'),(3,108,'Task',2,'create','--- \nname: \n- \"\"\n- BPWM001:5\nstart_date: \n- \n- 2006-12-18 12:45:09.753178 +00:00\nend_date: \n- \n- 2006-12-19 12:45:09.755288 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\n',NULL,'2006-12-18 12:45:09'),(4,108,'Task',2,'update','--- \nname: \n- \"\"\n- BPWM001:5\nstart_date: \n- \n- 2006-12-18 12:45:09.753178 +00:00\nend_date: \n- \n- 2006-12-19 12:45:09.755288 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\ndescription: \n- \n- This task is linked to external cvs file for import created called BPWM001-BPWM001:5.csv\n',NULL,'2006-12-18 12:45:09'),(5,108,'Task',2,'update','--- \nprocess_instance_id: \n- 98\n- \n',NULL,'2006-12-18 12:47:49'),(6,109,'Task',2,'create','--- \nname: \n- \"\"\n- BPWM001:6\nstart_date: \n- \n- 2006-12-18 12:49:08.588839 +00:00\nend_date: \n- \n- 2006-12-19 12:49:08.591020 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\n',NULL,'2006-12-18 12:49:08'),(7,109,'Task',2,'update','--- \nname: \n- \"\"\n- !str:CSV::Cell BPWM001:6\nstart_date: \n- \n- 2006-12-18 12:49:08.588839 +00:00\nend_date: \n- \n- 2006-12-19 12:49:08.591020 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\ndescription: \n- \n- Data Import from file\n',NULL,'2006-12-18 12:49:08'),(8,110,'Task',2,'create','--- \nname: \n- \"\"\n- BPWM001:7\nstart_date: \n- \n- 2006-12-18 12:51:00.669128 +00:00\nend_date: \n- \n- 2006-12-19 12:51:00.671284 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\n',NULL,'2006-12-18 12:51:00'),(9,110,'Task',2,'update','--- \nname: \n- \"\"\n- !str:CSV::Cell BPWM001:7\nstart_date: \n- \n- 2006-12-18 12:51:00.669128 +00:00\nend_date: \n- \n- 2006-12-19 12:51:00.671284 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\ndescription: \n- \n- Data Import from file\n',NULL,'2006-12-18 12:51:00'),(10,107,'Task',2,'update','--- {}\n\n',NULL,'2006-12-18 12:52:12'),(11,109,'Task',2,'update','--- \nassigned_to: \n- \n- thawkin\ndescription: \n- Data Import from file\n- \"\"\nstatus_id: \n- \n- \"1\"\nis_milestone: \n- \n- false\n',NULL,'2006-12-18 12:54:40'),(12,110,'Task',2,'update','--- \nassigned_to: \n- \n- thawkins\ndescription: \n- Data Import from file\n- \"\"\nstatus_id: \n- \n- \"1\"\nis_milestone: \n- \n- false\n',NULL,'2006-12-18 12:55:38'),(13,111,'Task',2,'create','--- \nname: \n- \"\"\n- BPWM001:8\nstart_date: \n- \n- 2006-12-18 12:57:05.945493 +00:00\nend_date: \n- \n- 2006-12-19 12:57:05.947659 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\n',NULL,'2006-12-18 12:57:05'),(14,112,'Task',2,'create','--- \nname: \n- \"\"\n- BPWM001:9\nstart_date: \n- \n- 2006-12-18 12:58:44.241148 +00:00\nend_date: \n- \n- 2006-12-19 12:58:44.243318 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\n',NULL,'2006-12-18 12:58:44'),(15,113,'Task',2,'create','--- \nname: \n- \"\"\n- BPWM001:10\nstart_date: \n- \n- 2006-12-18 13:00:56.182944 +00:00\nend_date: \n- \n- 2006-12-19 13:00:56.185084 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\n',NULL,'2006-12-18 13:00:56'),(16,113,'Task',2,'update','--- \nname: \n- \"\"\n- !str:CSV::Cell BPWM001:10\nstart_date: \n- \n- 2006-12-18 13:00:56.182944 +00:00\nend_date: \n- \n- 2006-12-19 13:00:56.185084 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\ndescription: \n- \n- Data Import from file\n',NULL,'2006-12-18 13:00:56'),(17,114,'Task',2,'create','--- \nname: \n- \"\"\n- BPWM001:11\nstart_date: \n- \n- 2006-12-18 13:02:39.950484 +00:00\nend_date: \n- \n- 2006-12-19 13:02:39.952711 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\n',NULL,'2006-12-18 13:02:40'),(18,114,'Task',2,'update','--- \nname: \n- \"\"\n- !str:CSV::Cell BPWM001:11\nstart_date: \n- \n- 2006-12-18 13:02:39.950484 +00:00\nend_date: \n- \n- 2006-12-19 13:02:39.952711 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\ndescription: \n- \n- Data Import from file\n',NULL,'2006-12-18 13:02:40'),(19,115,'Task',2,'create','--- \nname: \n- \"\"\n- BPWM001:12\nstart_date: \n- \n- 2006-12-18 13:03:55.397678 +00:00\nend_date: \n- \n- 2006-12-19 13:03:55.399860 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\n',NULL,'2006-12-18 13:03:55'),(20,115,'Task',2,'update','--- \nname: \n- \"\"\n- !str:CSV::Cell BPWM001:12\nstart_date: \n- \n- 2006-12-18 13:03:55.397678 +00:00\nend_date: \n- \n- 2006-12-19 13:03:55.399860 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\ndescription: \n- \n- Data Import from file\n',NULL,'2006-12-18 13:03:55'),(21,116,'Task',2,'create','--- \nname: \n- \"\"\n- BPWM001:13\nstart_date: \n- \n- 2006-12-18 13:05:26.893981 +00:00\nend_date: \n- \n- 2006-12-19 13:05:26.896160 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\n',NULL,'2006-12-18 13:05:26'),(22,116,'Task',2,'update','--- \nname: \n- \"\"\n- !str:CSV::Cell BPWM001:13\nstart_date: \n- \n- 2006-12-18 13:05:26.893981 +00:00\nend_date: \n- \n- 2006-12-19 13:05:26.896160 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\ndescription: \n- \n- Data Import from file\n',NULL,'2006-12-18 13:05:27'),(23,117,'Task',2,'create','--- \nname: \n- \"\"\n- BPWM001:14\nstart_date: \n- \n- 2006-12-18 13:08:17.598688 +00:00\nend_date: \n- \n- 2006-12-19 13:08:17.600936 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\n',NULL,'2006-12-18 13:08:17'),(24,117,'Task',2,'update','--- \nname: \n- \"\"\n- !str:CSV::Cell BPWM001:14\nstart_date: \n- \n- 2006-12-18 13:08:17.598688 +00:00\nend_date: \n- \n- 2006-12-19 13:08:17.600936 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\ndescription: \n- \n- Data Import from file\n',NULL,'2006-12-18 13:08:17'),(25,118,'Task',2,'create','--- \nname: \n- \"\"\n- BPWM001:15\nstart_date: \n- \n- 2006-12-18 13:11:29.160842 +00:00\nend_date: \n- \n- 2006-12-19 13:11:29.163070 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\n',NULL,'2006-12-18 13:11:29'),(26,118,'Task',2,'update','--- \nname: \n- \"\"\n- !str:CSV::Cell BPWM001:15\nstart_date: \n- \n- 2006-12-18 13:11:29.160842 +00:00\nend_date: \n- \n- 2006-12-19 13:11:29.163070 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\ndescription: \n- \n- Data Import from file\n',NULL,'2006-12-18 13:11:29'),(27,119,'Task',2,'create','--- \nname: \n- \"\"\n- BPWM001:16\nstart_date: \n- \n- 2006-12-18 13:13:33.988377 +00:00\nend_date: \n- \n- 2006-12-19 13:13:33.990657 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\n',NULL,'2006-12-18 13:13:34'),(28,119,'Task',2,'update','--- \nname: \n- \"\"\n- !str:CSV::Cell BPWM001:16\nstart_date: \n- \n- 2006-12-18 13:13:33.988377 +00:00\nend_date: \n- \n- 2006-12-19 13:13:33.990657 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\ndescription: \n- \n- Data Import from file\n',NULL,'2006-12-18 13:13:34'),(29,120,'Task',2,'create','--- \nname: \n- \"\"\n- BPWM001:17\nstart_date: \n- \n- 2006-12-18 13:15:09.341188 +00:00\nend_date: \n- \n- 2006-12-19 13:15:09.343380 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\n',NULL,'2006-12-18 13:15:09'),(30,120,'Task',2,'update','--- \nname: \n- \"\"\n- !str:CSV::Cell BPWM001:17\nstart_date: \n- \n- 2006-12-18 13:15:09.341188 +00:00\nend_date: \n- \n- 2006-12-19 13:15:09.343380 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\ndescription: \n- \n- Data Import from file\n',NULL,'2006-12-18 13:15:09'),(31,121,'Task',2,'create','--- \nname: \n- \"\"\n- BPWM001:18\nstart_date: \n- \n- 2006-12-18 13:17:42.973119 +00:00\nend_date: \n- \n- 2006-12-19 13:17:42.975281 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\n',NULL,'2006-12-18 13:17:43'),(32,121,'Task',2,'update','--- \nname: \n- \"\"\n- !str:CSV::Cell BPWM001:18\nstart_date: \n- \n- 2006-12-18 13:17:42.973119 +00:00\nend_date: \n- \n- 2006-12-19 13:17:42.975281 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\ndescription: \n- \n- Data Import from file\n',NULL,'2006-12-18 13:17:43'),(33,122,'Task',2,'create','--- \nname: \n- \"\"\n- BPWM001:19\nstart_date: \n- \n- 2006-12-18 13:19:54.092681 +00:00\nend_date: \n- \n- 2006-12-19 13:19:54.094879 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\n',NULL,'2006-12-18 13:19:54'),(34,122,'Task',2,'update','--- \nname: \n- \"\"\n- !str:CSV::Cell BPWM001:19\nstart_date: \n- \n- 2006-12-18 13:19:54.092681 +00:00\nend_date: \n- \n- 2006-12-19 13:19:54.094879 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 12\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 98\nstudy_protocol_id: \n- \n- 29\ndescription: \n- \n- Data Import from file\n',NULL,'2006-12-18 13:19:54'),(35,12,'Study',2,'update','--- \ndescription: \n- |-\n  Measure the effect of tumour volume (growth).  Need to <br />\r\n  <ol>\r\n      <li>Set up experiment\r\n      <ol>\r\n          <li>Experiment id</li>\r\n          <li>Implant Date</li>\r\n          <li>Tumour Type</li>\r\n          <li>Dosing</li>\r\n          <li>Strain/Source</li>\r\n          <li>Mean Tumour Size</li>\r\n          <li>Subjects</li>\r\n          <li>Vehicle(s)</li>\r\n          <li>Dosages</li>\r\n      </ol>\r\n      </li>\r\n      <li>Set up test groups\r\n      <ol>\r\n          <li>Number of groups</li>\r\n          <li>Animals per group</li>\r\n          <li>Measurement of days as days from implant</li>\r\n      </ol>\r\n      </li>\r\n      <li>Proved data entry sheet (Manual or XL import)\r\n      <ol>\r\n          <li>Tumour volume</li>\r\n          <li>Tumour Weight (g)</li>\r\n      </ol>\r\n      </li>\r\n      <li>Calculate\r\n      <ol>\r\n          <li>mean + SEM Volume by group by measurement date</li>\r\n          <li>mean - SEM Weight by group by measurement date</li>\r\n      </ol>\r\n      </li>\r\n      <li>Summary report</li>\r\n      <li>Generate Graphs\r\n      <ol>\r\n          <li>Time vs volume (+-SEM) by group</li>\r\n      </ol>\r\n      </li>\r\n  </ol>\n- |-\n  Measure the effect of tumour volume (growth).  Need to <br />\r\n  <ol>\r\n      <li>Set up experimentSet up test groups</li>\r\n      <li>Provide data entry sheet (Manual or XL import)          </li>\r\n      <li>Calculate</li>\r\n      <li>Summary report</li>\r\n      <li>Generate Graphs</li>\r\n  </ol>\n',NULL,'2006-12-18 13:23:12'),(36,12,'Study',2,'update','--- \ndescription: \n- |-\n  Measure the effect of tumour volume (growth).  Need to <br />\r\n  <ol>\r\n      <li>Set up experiment\r\n      <ol>\r\n          <li>Experiment id</li>\r\n          <li>Implant Date</li>\r\n          <li>Tumour Type</li>\r\n          <li>Dosing</li>\r\n          <li>Strain/Source</li>\r\n          <li>Mean Tumour Size</li>\r\n          <li>Subjects</li>\r\n          <li>Vehicle(s)</li>\r\n          <li>Dosages</li>\r\n      </ol>\r\n      </li>\r\n      <li>Set up test groups\r\n      <ol>\r\n          <li>Number of groups</li>\r\n          <li>Animals per group</li>\r\n          <li>Measurement of days as days from implant</li>\r\n      </ol>\r\n      </li>\r\n      <li>Proved data entry sheet (Manual or XL import)\r\n      <ol>\r\n          <li>Tumour volume</li>\r\n          <li>Tumour Weight (g)</li>\r\n      </ol>\r\n      </li>\r\n      <li>Calculate\r\n      <ol>\r\n          <li>mean + SEM Volume by group by measurement date</li>\r\n          <li>mean - SEM Weight by group by measurement date</li>\r\n      </ol>\r\n      </li>\r\n      <li>Summary report</li>\r\n      <li>Generate Graphs\r\n      <ol>\r\n          <li>Time vs volume (+-SEM) by group</li>\r\n      </ol>\r\n      </li>\r\n  </ol>\n- |-\n  Measure the effect of tumour volume (growth).  Need to <br />\r\n  <ol>\r\n      <li>Set up experimentSet up test groups</li>\r\n      <li>Provide data entry sheet (Manual or XL import)          </li>\r\n      <li>Calculate</li>\r\n      <li>Summary report</li>\r\n      <li>Generate Graphs</li>\r\n  </ol>\n',NULL,'2006-12-18 13:23:12'),(37,13,'Experiment',2,'create','--- \nname: \n- \"\"\n- BPWM002\nprocess_instance_id: \n- \n- 104\nstudy_protocol_id: \n- \n- 35\ndescription: \n- \n- Task in study Tumour Growth\nstudy_id: \n- \n- 12\n',NULL,'2006-12-18 13:24:31'),(38,123,'Task',2,'create','--- \nexperiment_id: \n- \n- 13\nend_date: \n- \n- 2006-12-11 00:00:00 +00:00\ndone_hours: \n- \n- 0.0\nstart_date: \n- \n- 2006-12-11 00:00:00 +00:00\nname: \n- \"\"\n- BPWM002-0\nexpected_hours: \n- \n- 1.0\nassigned_to: \n- \n- thawkins\nprocess_instance_id: \n- \n- 103\nstudy_protocol_id: \n- \n- 34\ndescription: \n- \n- \"\"\nstatus_id: \n- \n- \"1\"\nis_milestone: \n- \n- false\n',NULL,'2006-12-18 13:24:56'),(39,124,'Task',2,'create','--- \nexperiment_id: \n- \n- 13\nend_date: \n- \n- 2006-12-18 00:00:00 +00:00\ndone_hours: \n- \n- 0.0\nstart_date: \n- \n- 2006-12-18 00:00:00 +00:00\nname: \n- \"\"\n- BPWM002-1\nexpected_hours: \n- \n- 1.0\nassigned_to: \n- \n- rshell\nprocess_instance_id: \n- \n- 104\nstudy_protocol_id: \n- \n- 35\ndescription: \n- \n- \"\"\nstatus_id: \n- \n- \"1\"\nis_milestone: \n- \n- false\n',NULL,'2006-12-18 13:30:28'),(40,125,'Task',2,'create','--- \nname: \n- \"\"\n- BPWM002:2\nstart_date: \n- \n- 2006-12-18 13:31:00.316492 +00:00\nend_date: \n- \n- 2006-12-19 13:31:00.318601 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 13\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 104\nstudy_protocol_id: \n- \n- 35\n',NULL,'2006-12-18 13:31:00'),(41,125,'Task',2,'update','--- \nname: \n- \"\"\n- BPWM002:2\nstart_date: \n- \n- 2006-12-18 13:31:00.316492 +00:00\nend_date: \n- \n- 2006-12-19 13:31:00.318601 +00:00\ndone_hours: \n- \n- 0.0\nexperiment_id: \n- \n- 13\nexpected_hours: \n- \n- 1.0\nprocess_instance_id: \n- \n- 104\nstudy_protocol_id: \n- \n- 35\ndescription: \n- \n- This task is linked to external cvs file for import created called BPWM002-BPWM002:2.csv\n',NULL,'2006-12-18 13:31:00'),(42,125,'Task',2,'update','--- \nprocess_instance_id: \n- 104\n- \n',NULL,'2006-12-18 13:37:49');
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;

--
-- Table structure for table `audits`
--

DROP TABLE IF EXISTS `audits`;
CREATE TABLE `audits` (
  `id` int(11) NOT NULL auto_increment,
  `auditable_id` int(11) default NULL,
  `auditable_type` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `user_type` varchar(255) default NULL,
  `session` varchar(255) default NULL,
  `action` varchar(255) default NULL,
  `changes` text,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `auditable_index` (`auditable_id`,`auditable_type`),
  KEY `user_index` (`user_id`,`user_type`),
  KEY `audits_created_at_index` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `audits`
--


/*!40000 ALTER TABLE `audits` DISABLE KEYS */;
/*!40000 ALTER TABLE `audits` ENABLE KEYS */;

--
-- Table structure for table `batches`
--

DROP TABLE IF EXISTS `batches`;
CREATE TABLE `batches` (
  `id` int(11) NOT NULL auto_increment,
  `compound_id` int(11) NOT NULL default '0',
  `name` varchar(255) default NULL,
  `description` text,
  `external_ref` varchar(255) default NULL,
  `quantity_unit` varchar(255) default NULL,
  `quantity_value` float default NULL,
  `url` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default 'sys',
  `created_at` datetime NOT NULL default '0000-00-00 00:00:00',
  `updated_by` varchar(32) NOT NULL default 'sys',
  `updated_at` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`),
  KEY `batches_compound_fk` (`compound_id`),
  CONSTRAINT `batches_compound_fk` FOREIGN KEY (`compound_id`) REFERENCES `compounds` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `batches`
--


/*!40000 ALTER TABLE `batches` DISABLE KEYS */;
INSERT INTO `batches` VALUES (1,1,'BB002','desc','','',NULL,'',4,'sys','2006-11-28 14:51:00','sys','2006-11-28 16:45:42'),(2,1,'B02','another batch','','',NULL,'',1,'sys','2006-11-28 14:55:40','sys','2006-11-28 14:56:07'),(3,2,'BB003','Desc','','',NULL,'',1,'sys','2006-11-28 16:47:04','sys','2006-11-28 16:47:04'),(4,4,'AB004','desc','','',NULL,'',2,'sys','2006-11-28 16:48:02','sys','2006-11-28 16:50:09'),(5,3,'BB004','Desc','','',NULL,'',1,'sys','2006-11-28 16:50:44','sys','2006-11-28 16:50:44'),(6,31,'BB005','desc','','',NULL,'',1,'sys','2006-11-28 16:53:16','sys','2006-11-28 16:53:17'),(7,3,'BB006','desc','BB006','',NULL,'',1,'sys','2006-11-28 16:54:12','sys','2006-11-28 16:54:12'),(8,1,'BB007','desc','AB001-3','',NULL,'',1,'sys','2006-11-28 16:59:03','sys','2006-11-28 16:59:03'),(9,1,'BB008','deasc','AB001-4','',NULL,'',1,'sys','2006-11-28 16:59:43','sys','2006-11-28 16:59:43'),(10,1,'BB9','desc','AB001-4','',NULL,'',1,'sys','2006-11-28 17:06:01','sys','2006-11-28 17:06:01');
/*!40000 ALTER TABLE `batches` ENABLE KEYS */;

--
-- Table structure for table `catalog_logs`
--

DROP TABLE IF EXISTS `catalog_logs`;
CREATE TABLE `catalog_logs` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `auditable_id` int(11) default NULL,
  `auditable_type` varchar(255) default NULL,
  `action` varchar(255) default NULL,
  `name` varchar(255) default NULL,
  `comment` varchar(255) default NULL,
  `created_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `catalog_logs_user_id_index` (`user_id`),
  KEY `catalog_logs_auditable_type_index` (`auditable_type`,`auditable_id`),
  KEY `catalog_logs_created_at_index` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `catalog_logs`
--


/*!40000 ALTER TABLE `catalog_logs` DISABLE KEYS */;
INSERT INTO `catalog_logs` VALUES (1,NULL,2,'DataContext','Update','LegacyHTS',' Update of DataContext with with 2',NULL,'2006-12-06 10:04:52'),(2,NULL,1,'DataSystem','Update','Internal',' Update of DataSystem with with 1',NULL,'2006-12-06 14:04:17'),(3,NULL,1,'ParameterType','Update','XC50',' Update of ParameterType with with 1',NULL,'2006-12-08 20:04:55'),(4,NULL,1,'ParameterRole','Update','Observation',' Update of ParameterRole with with 1',NULL,'2006-12-08 20:41:04'),(5,NULL,2,'ParameterRole','Update','Result',' Update of ParameterRole with with 2',NULL,'2006-12-08 20:41:37'),(6,NULL,2,'ParameterRole','Update','Result',' Update of ParameterRole with with 2',NULL,'2006-12-08 20:41:50'),(7,NULL,3,'ParameterRole','Update','Setting',' Update of ParameterRole with with 3',NULL,'2006-12-08 20:44:58'),(8,NULL,4,'ParameterRole','Update','Subject',' Update of ParameterRole with with 4',NULL,'2006-12-08 20:45:53'),(9,NULL,5,'ParameterRole','Create','Publish',' Create of ParameterRole with with 5',NULL,'2006-12-08 20:46:16'),(10,NULL,15,'ParameterType','Create','Total Rearing',' Create of ParameterType with with 15',NULL,'2006-12-11 13:52:36'),(11,NULL,16,'ParameterType','Create','Total Activity',' Create of ParameterType with with 16',NULL,'2006-12-11 13:54:33'),(12,NULL,17,'ParameterType','Create','Centre Rearing',' Create of ParameterType with with 17',NULL,'2006-12-11 13:55:05'),(13,NULL,18,'ParameterType','Create','Front to back count ',' Create of ParameterType with with 18',NULL,'2006-12-11 13:55:47'),(14,NULL,19,'ParameterType','Create','Active Time',' Create of ParameterType with with 19',NULL,'2006-12-11 13:57:34'),(15,NULL,20,'ParameterType','Create','Mobile Time',' Create of ParameterType with with 20',NULL,'2006-12-11 13:58:03'),(16,NULL,21,'ParameterType','Create','Rearing time ',' Create of ParameterType with with 21',NULL,'2006-12-11 13:58:33'),(17,NULL,22,'ParameterType','Create','Age',' Create of ParameterType with with 22',NULL,'2006-12-11 13:58:54'),(18,NULL,23,'ParameterType','Create','Weeks',' Create of ParameterType with with 23',NULL,'2006-12-11 13:59:40'),(19,NULL,24,'ParameterType','Create','Weight Range',' Create of ParameterType with with 24',NULL,'2006-12-11 14:00:25'),(20,NULL,25,'ParameterType','Create','g',' Create of ParameterType with with 25',NULL,'2006-12-11 14:00:51'),(21,NULL,26,'ParameterType','Create','Sex',' Create of ParameterType with with 26',NULL,'2006-12-11 14:01:23'),(22,NULL,27,'ParameterType','Create','Experimenent Duration',' Create of ParameterType with with 27',NULL,'2006-12-11 14:02:12'),(23,NULL,28,'ParameterType','Create','h',' Create of ParameterType with with 28',NULL,'2006-12-11 14:02:30'),(24,NULL,29,'ParameterType','Create','Control',' Create of ParameterType with with 29',NULL,'2006-12-11 14:04:16'),(25,NULL,30,'ParameterType','Create','Vehicle',' Create of ParameterType with with 30',NULL,'2006-12-11 14:05:21'),(26,NULL,31,'ParameterType','Create','Cage Number',' Create of ParameterType with with 31',NULL,'2006-12-11 14:06:25'),(27,NULL,32,'ParameterType','Create','Treatment Group',' Create of ParameterType with with 32',NULL,'2006-12-11 14:07:01'),(28,NULL,33,'ParameterType','Create','No. Animals',' Create of ParameterType with with 33',NULL,'2006-12-11 14:12:05'),(29,NULL,34,'ParameterType','Create','Dose Levels',' Create of ParameterType with with 34',NULL,'2006-12-11 14:12:29'),(30,NULL,35,'ParameterType','Create','Route of Admin',' Create of ParameterType with with 35',NULL,'2006-12-11 14:14:03'),(31,NULL,29,'ParameterType','Update','Control',' Update of ParameterType with with 29',NULL,'2006-12-11 14:14:40'),(32,NULL,30,'ParameterType','Update','Vehicle',' Update of ParameterType with with 30',NULL,'2006-12-11 14:14:51'),(33,NULL,6,'ParameterRole','Create','Pos Ctrl',' Create of ParameterRole with with 6',NULL,'2006-12-11 14:16:04'),(34,NULL,7,'ParameterRole','Create','Neg Ctrl',' Create of ParameterRole with with 7',NULL,'2006-12-11 14:16:22'),(35,NULL,8,'ParameterRole','Create','Vehicle',' Create of ParameterRole with with 8',NULL,'2006-12-11 14:16:41'),(36,NULL,6,'ParameterRole','Update','PosCtrl',' Update of ParameterRole with with 6',NULL,'2006-12-11 14:18:12'),(37,NULL,7,'ParameterRole','Update','NegCtrl',' Update of ParameterRole with with 7',NULL,'2006-12-11 14:18:17'),(38,NULL,30,'ParameterType','Destroy','Vehicle',' Destroy of ParameterType with with 30',NULL,'2006-12-11 14:19:07'),(39,NULL,29,'ParameterType','Destroy','Control',' Destroy of ParameterType with with 29',NULL,'2006-12-11 14:19:13'),(40,NULL,12,'ParameterType','Update','Sample',' Update of ParameterType with with 12',NULL,'2006-12-11 14:22:47'),(41,NULL,36,'ParameterType','Create','Obs No',' Create of ParameterType with with 36',NULL,'2006-12-11 14:28:48'),(42,NULL,37,'ParameterType','Create','Correction Factor',' Create of ParameterType with with 37',NULL,'2006-12-11 14:34:13'),(43,NULL,38,'ParameterType','Create','Correction Factor Type',' Create of ParameterType with with 38',NULL,'2006-12-11 14:34:39'),(44,NULL,39,'ParameterType','Create','Dose Volume',' Create of ParameterType with with 39',NULL,'2006-12-11 14:35:02'),(45,NULL,40,'ParameterType','Create','Supplier',' Create of ParameterType with with 40',NULL,'2006-12-11 14:35:25'),(46,NULL,41,'ParameterType','Create','Lot No.',' Create of ParameterType with with 41',NULL,'2006-12-11 14:35:52'),(47,NULL,42,'ParameterType','Create','Stock',' Create of ParameterType with with 42',NULL,'2006-12-11 14:36:17'),(48,NULL,28,'ParameterType','Update','h',' Update of ParameterType with with 28',NULL,'2006-12-11 14:40:55'),(49,NULL,39,'ParameterType','Destroy','Dose Volume',' Destroy of ParameterType with with 39',NULL,'2006-12-11 14:43:17'),(50,NULL,43,'ParameterType','Create','Mean',' Create of ParameterType with with 43',NULL,'2006-12-11 16:00:20'),(51,NULL,44,'ParameterType','Create','SEM',' Create of ParameterType with with 44',NULL,'2006-12-11 16:12:48'),(52,NULL,45,'ParameterType','Create','AnimalID',' Create of ParameterType with with 45',NULL,'2006-12-11 16:24:48'),(53,NULL,46,'ParameterType','Create','Animal No.',' Create of ParameterType with with 46',NULL,'2006-12-11 16:25:15'),(54,NULL,5,'StudyStage','Create','Preparation',' Create of StudyStage with with 5',NULL,'2006-12-11 18:32:33'),(55,NULL,6,'StudyStage','Create','Data Capture',' Create of StudyStage with with 6',NULL,'2006-12-11 18:32:56'),(56,NULL,7,'StudyStage','Create','QC',' Create of StudyStage with with 7',NULL,'2006-12-11 18:33:09'),(57,NULL,8,'StudyStage','Create','Analysis',' Create of StudyStage with with 8',NULL,'2006-12-11 18:33:23'),(58,NULL,9,'StudyStage','Create','Publication',' Create of StudyStage with with 9',NULL,'2006-12-11 18:33:45'),(59,NULL,1,'StudyStage','Destroy','Primary',' Destroy of StudyStage with with 1',NULL,'2006-12-11 18:36:26'),(60,NULL,2,'StudyStage','Destroy','Confirmation',' Destroy of StudyStage with with 2',NULL,'2006-12-11 18:36:30'),(61,NULL,3,'StudyStage','Destroy','DoseResponse',' Destroy of StudyStage with with 3',NULL,'2006-12-11 18:36:34'),(62,NULL,4,'StudyStage','Destroy','Profile',' Destroy of StudyStage with with 4',NULL,'2006-12-11 18:36:37'),(63,NULL,47,'ParameterType','Create','Treatment',' Create of ParameterType with with 47',NULL,'2006-12-11 18:53:53'),(64,NULL,48,'ParameterType','Create','Bin',' Create of ParameterType with with 48',NULL,'2006-12-11 19:20:52'),(65,NULL,49,'ParameterType','Create','Role',' Create of ParameterType with with 49',NULL,'2006-12-11 19:52:04'),(66,NULL,38,'ParameterType','Destroy','Correction Factor Type',' Destroy of ParameterType with with 38',NULL,'2006-12-11 20:16:37'),(67,NULL,9,'ParameterType','Update','Batch',' Update of ParameterType with with 9',NULL,'2006-12-11 20:22:21'),(68,NULL,7,'ParameterRole','Destroy','NegCtrl',' Destroy of ParameterRole with with 7',NULL,'2006-12-12 13:16:46'),(69,NULL,8,'ParameterRole','Destroy','Vehicle',' Destroy of ParameterRole with with 8',NULL,'2006-12-12 13:16:50'),(70,NULL,6,'ParameterRole','Destroy','PosCtrl',' Destroy of ParameterRole with with 6',NULL,'2006-12-12 13:16:59'),(71,NULL,32,'DataConcept','Create','Route',' Create of DataConcept with with 32',NULL,'2006-12-12 13:51:47'),(72,NULL,33,'DataConcept','Create','Times',' Create of DataConcept with with 33',NULL,'2006-12-12 13:53:02'),(73,NULL,12,'DataElement','Create','Route',' Create of DataElement with with 12',NULL,'2006-12-12 14:02:35'),(74,NULL,34,'DataConcept','Create','Lookup',' Create of DataConcept with with 34',NULL,'2006-12-12 14:14:10'),(75,NULL,35,'DataConcept','Create','Sex',' Create of DataConcept with with 35',NULL,'2006-12-12 14:14:33'),(76,NULL,35,'DataConcept','Update','Sex',' Update of DataConcept with with 35',NULL,'2006-12-12 14:14:33'),(77,NULL,36,'DataConcept','Create','Route',' Create of DataConcept with with 36',NULL,'2006-12-12 14:14:57'),(78,NULL,36,'DataConcept','Update','Route',' Update of DataConcept with with 36',NULL,'2006-12-12 14:14:57'),(79,NULL,37,'DataConcept','Create','Score',' Create of DataConcept with with 37',NULL,'2006-12-12 14:15:44'),(80,NULL,37,'DataConcept','Update','Score',' Update of DataConcept with with 37',NULL,'2006-12-12 14:15:44'),(81,NULL,13,'DataElement','Create','sexs',' Create of DataElement with with 13',NULL,'2006-12-12 14:17:03'),(82,NULL,50,'ParameterType','Create','sexy',' Create of ParameterType with with 50',NULL,'2006-12-12 14:18:16'),(83,NULL,35,'DataConcept','Update','Sex',' Update of DataConcept with with 35',NULL,'2006-12-12 15:01:50'),(84,NULL,38,'DataConcept','Create','1',' Create of DataConcept with with 38',NULL,'2006-12-12 15:40:17'),(85,NULL,38,'DataConcept','Update','1',' Update of DataConcept with with 38',NULL,'2006-12-12 15:40:18'),(86,NULL,39,'DataConcept','Create','iv',' Create of DataConcept with with 39',NULL,'2006-12-12 15:42:15'),(87,NULL,39,'DataConcept','Update','iv',' Update of DataConcept with with 39',NULL,'2006-12-12 15:42:15'),(88,NULL,40,'DataConcept','Create','ia',' Create of DataConcept with with 40',NULL,'2006-12-12 15:42:36'),(89,NULL,40,'DataConcept','Update','ia',' Update of DataConcept with with 40',NULL,'2006-12-12 15:42:36'),(90,NULL,39,'DataConcept','Destroy','iv',' Destroy of DataConcept with with 39',NULL,'2006-12-12 15:44:45'),(91,NULL,40,'DataConcept','Update','ia',' Update of DataConcept with with 40',NULL,'2006-12-12 15:45:35'),(92,NULL,40,'DataConcept','Destroy','ia',' Destroy of DataConcept with with 40',NULL,'2006-12-12 15:45:41'),(93,NULL,32,'DataConcept','Update','Routen of Administration',' Update of DataConcept with with 32',NULL,'2006-12-12 15:48:07'),(94,NULL,32,'DataConcept','Update','Route of Administration',' Update of DataConcept with with 32',NULL,'2006-12-12 15:50:13'),(95,NULL,41,'DataConcept','Create','Topical',' Create of DataConcept with with 41',NULL,'2006-12-12 15:50:57'),(96,NULL,41,'DataConcept','Update','Topical',' Update of DataConcept with with 41',NULL,'2006-12-12 15:50:57'),(97,NULL,42,'DataConcept','Create','Enteral',' Create of DataConcept with with 42',NULL,'2006-12-12 15:51:45'),(98,NULL,42,'DataConcept','Update','Enteral',' Update of DataConcept with with 42',NULL,'2006-12-12 15:51:46'),(99,NULL,43,'DataConcept','Create','Parenteral',' Create of DataConcept with with 43',NULL,'2006-12-12 15:53:15'),(100,NULL,43,'DataConcept','Update','Parenteral',' Update of DataConcept with with 43',NULL,'2006-12-12 15:53:15'),(101,NULL,44,'DataConcept','Create','Other',' Create of DataConcept with with 44',NULL,'2006-12-12 15:54:01'),(102,NULL,44,'DataConcept','Update','Other',' Update of DataConcept with with 44',NULL,'2006-12-12 15:54:01'),(103,NULL,45,'DataConcept','Create','Epicutaneous',' Create of DataConcept with with 45',NULL,'2006-12-12 15:59:17'),(104,NULL,45,'DataConcept','Update','Epicutaneous',' Update of DataConcept with with 45',NULL,'2006-12-12 15:59:17'),(105,NULL,45,'DataConcept','Update','ep',' Update of DataConcept with with 45',NULL,'2006-12-12 15:59:43'),(106,NULL,46,'DataConcept','Create','ih',' Create of DataConcept with with 46',NULL,'2006-12-12 16:00:38'),(107,NULL,46,'DataConcept','Update','ih',' Update of DataConcept with with 46',NULL,'2006-12-12 16:00:38'),(108,NULL,47,'DataConcept','Create','en',' Create of DataConcept with with 47',NULL,'2006-12-12 16:01:13'),(109,NULL,47,'DataConcept','Update','en',' Update of DataConcept with with 47',NULL,'2006-12-12 16:01:13'),(110,NULL,48,'DataConcept','Create','ed',' Create of DataConcept with with 48',NULL,'2006-12-12 16:01:40'),(111,NULL,48,'DataConcept','Update','ed',' Update of DataConcept with with 48',NULL,'2006-12-12 16:01:41'),(112,NULL,49,'DataConcept','Create','er',' Create of DataConcept with with 49',NULL,'2006-12-12 16:02:20'),(113,NULL,49,'DataConcept','Update','er',' Update of DataConcept with with 49',NULL,'2006-12-12 16:02:20'),(114,NULL,50,'DataConcept','Create','in',' Create of DataConcept with with 50',NULL,'2006-12-12 16:02:57'),(115,NULL,50,'DataConcept','Update','in',' Update of DataConcept with with 50',NULL,'2006-12-12 16:02:57'),(116,NULL,51,'DataConcept','Create','vg',' Create of DataConcept with with 51',NULL,'2006-12-12 16:03:33'),(117,NULL,51,'DataConcept','Update','vg',' Update of DataConcept with with 51',NULL,'2006-12-12 16:03:33'),(118,NULL,52,'DataConcept','Create','ed',' Create of DataConcept with with 52',NULL,'2006-12-12 16:04:30'),(119,NULL,52,'DataConcept','Update','ed',' Update of DataConcept with with 52',NULL,'2006-12-12 16:04:30'),(120,NULL,53,'DataConcept','Create','iv',' Create of DataConcept with with 53',NULL,'2006-12-12 16:06:30'),(121,NULL,53,'DataConcept','Update','iv',' Update of DataConcept with with 53',NULL,'2006-12-12 16:06:30'),(122,NULL,54,'DataConcept','Create','ia',' Create of DataConcept with with 54',NULL,'2006-12-12 16:07:03'),(123,NULL,54,'DataConcept','Update','ia',' Update of DataConcept with with 54',NULL,'2006-12-12 16:07:03'),(124,NULL,55,'DataConcept','Create','im',' Create of DataConcept with with 55',NULL,'2006-12-12 16:07:29'),(125,NULL,55,'DataConcept','Update','im',' Update of DataConcept with with 55',NULL,'2006-12-12 16:07:29'),(126,NULL,56,'DataConcept','Create','ic',' Create of DataConcept with with 56',NULL,'2006-12-12 16:07:57'),(127,NULL,56,'DataConcept','Update','ic',' Update of DataConcept with with 56',NULL,'2006-12-12 16:07:57'),(128,NULL,57,'DataConcept','Create','sc',' Create of DataConcept with with 57',NULL,'2006-12-12 16:08:41'),(129,NULL,57,'DataConcept','Update','sc',' Update of DataConcept with with 57',NULL,'2006-12-12 16:08:41'),(130,NULL,58,'DataConcept','Create','io',' Create of DataConcept with with 58',NULL,'2006-12-12 16:09:22'),(131,NULL,58,'DataConcept','Update','io',' Update of DataConcept with with 58',NULL,'2006-12-12 16:09:22'),(132,NULL,59,'DataConcept','Create','id',' Create of DataConcept with with 59',NULL,'2006-12-12 16:09:54'),(133,NULL,59,'DataConcept','Update','id',' Update of DataConcept with with 59',NULL,'2006-12-12 16:09:54'),(134,NULL,60,'DataConcept','Create','it',' Create of DataConcept with with 60',NULL,'2006-12-12 16:10:42'),(135,NULL,60,'DataConcept','Update','it',' Update of DataConcept with with 60',NULL,'2006-12-12 16:10:43'),(136,NULL,61,'DataConcept','Create','ip',' Create of DataConcept with with 61',NULL,'2006-12-12 16:11:07'),(137,NULL,61,'DataConcept','Update','ip',' Update of DataConcept with with 61',NULL,'2006-12-12 16:11:07'),(138,NULL,41,'DataConcept','Destroy','Topical',' Destroy of DataConcept with with 41',NULL,'2006-12-12 16:12:12'),(139,NULL,42,'DataConcept','Update','Topical',' Update of DataConcept with with 42',NULL,'2006-12-12 16:12:40'),(140,NULL,62,'DataConcept','Create','Enteral',' Create of DataConcept with with 62',NULL,'2006-12-12 16:13:58'),(141,NULL,62,'DataConcept','Update','Enteral',' Update of DataConcept with with 62',NULL,'2006-12-12 16:13:58'),(142,NULL,63,'DataConcept','Create','po',' Create of DataConcept with with 63',NULL,'2006-12-12 16:14:37'),(143,NULL,63,'DataConcept','Update','po',' Update of DataConcept with with 63',NULL,'2006-12-12 16:14:37'),(144,NULL,64,'DataConcept','Create','gft',' Create of DataConcept with with 64',NULL,'2006-12-12 16:15:02'),(145,NULL,64,'DataConcept','Update','gft',' Update of DataConcept with with 64',NULL,'2006-12-12 16:15:02'),(146,NULL,65,'DataConcept','Create','re',' Create of DataConcept with with 65',NULL,'2006-12-12 16:15:29'),(147,NULL,65,'DataConcept','Update','re',' Update of DataConcept with with 65',NULL,'2006-12-12 16:15:29'),(148,NULL,66,'DataConcept','Create','Route',' Create of DataConcept with with 66',NULL,'2006-12-12 16:16:59'),(149,NULL,67,'DataConcept','Create','po',' Create of DataConcept with with 67',NULL,'2006-12-12 16:17:30'),(150,NULL,67,'DataConcept','Update','po',' Update of DataConcept with with 67',NULL,'2006-12-12 16:17:30'),(151,NULL,68,'DataConcept','Create','sc',' Create of DataConcept with with 68',NULL,'2006-12-12 16:17:59'),(152,NULL,68,'DataConcept','Update','sc',' Update of DataConcept with with 68',NULL,'2006-12-12 16:18:00'),(153,NULL,69,'DataConcept','Create','im',' Create of DataConcept with with 69',NULL,'2006-12-12 16:18:36'),(154,NULL,69,'DataConcept','Update','im',' Update of DataConcept with with 69',NULL,'2006-12-12 16:18:36'),(155,NULL,70,'DataConcept','Create','ip',' Create of DataConcept with with 70',NULL,'2006-12-12 16:19:12'),(156,NULL,70,'DataConcept','Update','ip',' Update of DataConcept with with 70',NULL,'2006-12-12 16:19:12'),(157,NULL,71,'DataConcept','Create','iv',' Create of DataConcept with with 71',NULL,'2006-12-12 16:19:48'),(158,NULL,71,'DataConcept','Update','iv',' Update of DataConcept with with 71',NULL,'2006-12-12 16:19:48'),(159,NULL,2,'DataConcept','Destroy','Classification',' Destroy of DataConcept with with 2',NULL,'2006-12-12 16:25:33'),(160,NULL,72,'DataConcept','Create','Role',' Create of DataConcept with with 72',NULL,'2006-12-12 16:27:33'),(161,NULL,73,'DataConcept','Create','PosCtrl',' Create of DataConcept with with 73',NULL,'2006-12-12 16:28:06'),(162,NULL,73,'DataConcept','Update','PosCtrl',' Update of DataConcept with with 73',NULL,'2006-12-12 16:28:07'),(163,NULL,74,'DataConcept','Create','NegCtrl',' Create of DataConcept with with 74',NULL,'2006-12-12 16:28:25'),(164,NULL,74,'DataConcept','Update','NegCtrl',' Update of DataConcept with with 74',NULL,'2006-12-12 16:28:25'),(165,NULL,75,'DataConcept','Create','Subject',' Create of DataConcept with with 75',NULL,'2006-12-12 16:28:57'),(166,NULL,75,'DataConcept','Update','Subject',' Update of DataConcept with with 75',NULL,'2006-12-12 16:28:58'),(167,NULL,76,'DataConcept','Create','Reference',' Create of DataConcept with with 76',NULL,'2006-12-12 16:30:08'),(168,NULL,76,'DataConcept','Update','Reference',' Update of DataConcept with with 76',NULL,'2006-12-12 16:30:08'),(169,NULL,77,'DataConcept','Create','Standard',' Create of DataConcept with with 77',NULL,'2006-12-12 16:31:00'),(170,NULL,77,'DataConcept','Update','Standard',' Update of DataConcept with with 77',NULL,'2006-12-12 16:31:00'),(171,NULL,72,'DataConcept','Update','Subject Role',' Update of DataConcept with with 72',NULL,'2006-12-12 16:32:07'),(172,NULL,14,'DataElement','Create','Local_Studies',' Create of SqlElement with with 14',NULL,'2006-12-12 18:07:09'),(173,NULL,15,'DataElement','Create','more_studies',' Create of SqlElement with with 15',NULL,'2006-12-12 18:58:10'),(174,NULL,16,'DataElement','Create','more_studies2',' Create of SqlElement with with 16',NULL,'2006-12-12 18:59:19'),(175,NULL,16,'DataElement','Update','more_studies2',' Update of SqlElement with with 16',NULL,'2006-12-12 19:00:02'),(176,NULL,64,'DataConcept','Destroy','gft',' Destroy of DataConcept with with 64',NULL,'2006-12-12 20:39:55'),(177,NULL,63,'DataConcept','Destroy','po',' Destroy of DataConcept with with 63',NULL,'2006-12-12 20:39:55'),(178,NULL,65,'DataConcept','Destroy','re',' Destroy of DataConcept with with 65',NULL,'2006-12-12 20:39:55'),(179,NULL,62,'DataConcept','Destroy','Enteral',' Destroy of DataConcept with with 62',NULL,'2006-12-12 20:39:55'),(180,NULL,52,'DataConcept','Destroy','ed',' Destroy of DataConcept with with 52',NULL,'2006-12-12 20:39:55'),(181,NULL,44,'DataConcept','Destroy','Other',' Destroy of DataConcept with with 44',NULL,'2006-12-12 20:39:55'),(182,NULL,54,'DataConcept','Destroy','ia',' Destroy of DataConcept with with 54',NULL,'2006-12-12 20:39:55'),(183,NULL,56,'DataConcept','Destroy','ic',' Destroy of DataConcept with with 56',NULL,'2006-12-12 20:39:55'),(184,NULL,59,'DataConcept','Destroy','id',' Destroy of DataConcept with with 59',NULL,'2006-12-12 20:39:55'),(185,NULL,55,'DataConcept','Destroy','im',' Destroy of DataConcept with with 55',NULL,'2006-12-12 20:39:55'),(186,NULL,58,'DataConcept','Destroy','io',' Destroy of DataConcept with with 58',NULL,'2006-12-12 20:39:55'),(187,NULL,61,'DataConcept','Destroy','ip',' Destroy of DataConcept with with 61',NULL,'2006-12-12 20:39:55'),(188,NULL,60,'DataConcept','Destroy','it',' Destroy of DataConcept with with 60',NULL,'2006-12-12 20:39:55'),(189,NULL,53,'DataConcept','Destroy','iv',' Destroy of DataConcept with with 53',NULL,'2006-12-12 20:39:55'),(190,NULL,57,'DataConcept','Destroy','sc',' Destroy of DataConcept with with 57',NULL,'2006-12-12 20:39:55'),(191,NULL,43,'DataConcept','Destroy','Parenteral',' Destroy of DataConcept with with 43',NULL,'2006-12-12 20:39:55'),(192,NULL,48,'DataConcept','Destroy','ed',' Destroy of DataConcept with with 48',NULL,'2006-12-12 20:39:55'),(193,NULL,47,'DataConcept','Destroy','en',' Destroy of DataConcept with with 47',NULL,'2006-12-12 20:39:55'),(194,NULL,45,'DataConcept','Destroy','ep',' Destroy of DataConcept with with 45',NULL,'2006-12-12 20:39:55'),(195,NULL,49,'DataConcept','Destroy','er',' Destroy of DataConcept with with 49',NULL,'2006-12-12 20:39:55'),(196,NULL,46,'DataConcept','Destroy','ih',' Destroy of DataConcept with with 46',NULL,'2006-12-12 20:39:55'),(197,NULL,50,'DataConcept','Destroy','in',' Destroy of DataConcept with with 50',NULL,'2006-12-12 20:39:55'),(198,NULL,51,'DataConcept','Destroy','vg',' Destroy of DataConcept with with 51',NULL,'2006-12-12 20:39:55'),(199,NULL,42,'DataConcept','Destroy','Topical',' Destroy of DataConcept with with 42',NULL,'2006-12-12 20:39:55'),(200,NULL,32,'DataConcept','Destroy','Route of Administration',' Destroy of DataConcept with with 32',NULL,'2006-12-12 20:39:55'),(201,NULL,69,'DataConcept','Destroy','im',' Destroy of DataConcept with with 69',NULL,'2006-12-12 20:40:06'),(202,NULL,70,'DataConcept','Destroy','ip',' Destroy of DataConcept with with 70',NULL,'2006-12-12 20:40:06'),(203,NULL,71,'DataConcept','Destroy','iv',' Destroy of DataConcept with with 71',NULL,'2006-12-12 20:40:06'),(204,NULL,67,'DataConcept','Destroy','po',' Destroy of DataConcept with with 67',NULL,'2006-12-12 20:40:06'),(205,NULL,68,'DataConcept','Destroy','sc',' Destroy of DataConcept with with 68',NULL,'2006-12-12 20:40:06'),(206,NULL,66,'DataConcept','Destroy','Route',' Destroy of DataConcept with with 66',NULL,'2006-12-12 20:40:06'),(207,NULL,74,'DataConcept','Destroy','NegCtrl',' Destroy of DataConcept with with 74',NULL,'2006-12-12 20:40:25'),(208,NULL,73,'DataConcept','Destroy','PosCtrl',' Destroy of DataConcept with with 73',NULL,'2006-12-12 20:40:38'),(209,NULL,76,'DataConcept','Destroy','Reference',' Destroy of DataConcept with with 76',NULL,'2006-12-12 20:40:54'),(210,NULL,77,'DataConcept','Destroy','Standard',' Destroy of DataConcept with with 77',NULL,'2006-12-12 20:41:05'),(211,NULL,75,'DataConcept','Destroy','Subject',' Destroy of DataConcept with with 75',NULL,'2006-12-12 20:41:22'),(212,NULL,17,'DataElement','Create','Role',' Create of ListElement with with 17',NULL,'2006-12-12 20:58:27'),(213,NULL,25,'ParameterType','Destroy','g',' Destroy of ParameterType with with 25',NULL,'2006-12-12 20:59:19'),(214,NULL,24,'ParameterType','Destroy','Weight Range',' Destroy of ParameterType with with 24',NULL,'2006-12-12 20:59:23'),(215,NULL,23,'ParameterType','Destroy','Weeks',' Destroy of ParameterType with with 23',NULL,'2006-12-12 20:59:26'),(216,NULL,22,'ParameterType','Destroy','Age',' Destroy of ParameterType with with 22',NULL,'2006-12-12 20:59:29'),(217,NULL,21,'ParameterType','Destroy','Rearing time ',' Destroy of ParameterType with with 21',NULL,'2006-12-12 20:59:35'),(218,NULL,20,'ParameterType','Destroy','Mobile Time',' Destroy of ParameterType with with 20',NULL,'2006-12-12 20:59:37'),(219,NULL,19,'ParameterType','Destroy','Active Time',' Destroy of ParameterType with with 19',NULL,'2006-12-12 20:59:40'),(220,NULL,18,'ParameterType','Destroy','Front to back count ',' Destroy of ParameterType with with 18',NULL,'2006-12-12 20:59:43'),(221,NULL,17,'ParameterType','Destroy','Centre Rearing',' Destroy of ParameterType with with 17',NULL,'2006-12-12 20:59:46'),(222,NULL,16,'ParameterType','Destroy','Total Activity',' Destroy of ParameterType with with 16',NULL,'2006-12-12 20:59:49'),(223,NULL,15,'ParameterType','Destroy','Total Rearing',' Destroy of ParameterType with with 15',NULL,'2006-12-12 20:59:53'),(224,NULL,50,'ParameterType','Destroy','sexy',' Destroy of ParameterType with with 50',NULL,'2006-12-12 21:00:04'),(225,NULL,49,'ParameterType','Destroy','Role',' Destroy of ParameterType with with 49',NULL,'2006-12-12 21:00:08'),(226,NULL,48,'ParameterType','Destroy','Bin',' Destroy of ParameterType with with 48',NULL,'2006-12-12 21:00:11'),(227,NULL,47,'ParameterType','Destroy','Treatment',' Destroy of ParameterType with with 47',NULL,'2006-12-12 21:00:14'),(228,NULL,46,'ParameterType','Destroy','Animal No.',' Destroy of ParameterType with with 46',NULL,'2006-12-12 21:00:17'),(229,NULL,45,'ParameterType','Destroy','AnimalID',' Destroy of ParameterType with with 45',NULL,'2006-12-12 21:00:22'),(230,NULL,44,'ParameterType','Destroy','SEM',' Destroy of ParameterType with with 44',NULL,'2006-12-12 21:00:26'),(231,NULL,43,'ParameterType','Destroy','Mean',' Destroy of ParameterType with with 43',NULL,'2006-12-12 21:00:29'),(232,NULL,42,'ParameterType','Destroy','Stock',' Destroy of ParameterType with with 42',NULL,'2006-12-12 21:00:32'),(233,NULL,41,'ParameterType','Destroy','Lot No.',' Destroy of ParameterType with with 41',NULL,'2006-12-12 21:00:35'),(234,NULL,28,'ParameterType','Destroy','h',' Destroy of ParameterType with with 28',NULL,'2006-12-12 21:00:47'),(235,NULL,31,'ParameterType','Destroy','Cage Number',' Destroy of ParameterType with with 31',NULL,'2006-12-12 21:00:50'),(236,NULL,32,'ParameterType','Destroy','Treatment Group',' Destroy of ParameterType with with 32',NULL,'2006-12-12 21:00:53'),(237,NULL,33,'ParameterType','Destroy','No. Animals',' Destroy of ParameterType with with 33',NULL,'2006-12-12 21:00:57'),(238,NULL,34,'ParameterType','Destroy','Dose Levels',' Destroy of ParameterType with with 34',NULL,'2006-12-12 21:01:01'),(239,NULL,36,'ParameterType','Destroy','Obs No',' Destroy of ParameterType with with 36',NULL,'2006-12-12 21:01:05'),(240,NULL,37,'ParameterType','Destroy','Correction Factor',' Destroy of ParameterType with with 37',NULL,'2006-12-12 21:01:08'),(241,NULL,35,'ParameterType','Destroy','Route of Admin',' Destroy of ParameterType with with 35',NULL,'2006-12-12 21:01:17'),(242,NULL,40,'ParameterType','Destroy','Supplier',' Destroy of ParameterType with with 40',NULL,'2006-12-12 21:01:20'),(243,NULL,27,'ParameterType','Destroy','Experimenent Duration',' Destroy of ParameterType with with 27',NULL,'2006-12-12 21:01:23'),(244,NULL,26,'ParameterType','Destroy','Sex',' Destroy of ParameterType with with 26',NULL,'2006-12-12 21:01:28'),(245,NULL,51,'ParameterType','Create','Role',' Create of ParameterType with with 51',NULL,'2006-12-12 21:24:21'),(246,NULL,18,'DataElement','Create','Rout of Admin',' Create of ListElement with with 18',NULL,'2006-12-13 09:45:14'),(247,NULL,19,'DataElement','Create','Sex',' Create of ListElement with with 19',NULL,'2006-12-13 09:46:39'),(248,NULL,52,'ParameterType','Create','Activity',' Create of ParameterType with with 52',NULL,'2006-12-13 09:49:13'),(249,NULL,52,'ParameterType','Update','Activity',' Update of ParameterType with with 52',NULL,'2006-12-13 09:49:29'),(250,NULL,1,'ParameterType','Update','XC50',' Update of ParameterType with with 1',NULL,'2006-12-13 09:49:32'),(251,NULL,53,'ParameterType','Create','CF',' Create of ParameterType with with 53',NULL,'2006-12-13 09:50:06'),(252,NULL,54,'ParameterType','Create','Route',' Create of ParameterType with with 54',NULL,'2006-12-13 09:51:00'),(253,NULL,55,'ParameterType','Create','Sex',' Create of ParameterType with with 55',NULL,'2006-12-13 09:51:26'),(254,NULL,56,'ParameterType','Create','Dose Volume',' Create of ParameterType with with 56',NULL,'2006-12-13 09:51:54'),(255,NULL,6,'ParameterRole','Create','Condition',' Create of ParameterRole with with 6',NULL,'2006-12-13 09:53:50'),(256,NULL,1,'ParameterRole','Update','Observation',' Update of ParameterRole with with 1',NULL,'2006-12-13 09:54:00'),(257,NULL,6,'ParameterRole','Update','Condition',' Update of ParameterRole with with 6',NULL,'2006-12-13 09:54:09'),(258,NULL,2,'ParameterRole','Update','Result',' Update of ParameterRole with with 2',NULL,'2006-12-13 09:54:22'),(259,NULL,5,'ParameterRole','Update','Publish',' Update of ParameterRole with with 5',NULL,'2006-12-13 09:54:28'),(260,NULL,3,'ParameterRole','Update','Setting',' Update of ParameterRole with with 3',NULL,'2006-12-13 09:54:43'),(261,NULL,4,'ParameterType','Update','Dose',' Update of ParameterType with with 4',NULL,'2006-12-13 10:06:36'),(262,NULL,57,'ParameterType','Create','Weight',' Create of ParameterType with with 57',NULL,'2006-12-13 10:07:11'),(263,NULL,58,'ParameterType','Create','Age',' Create of ParameterType with with 58',NULL,'2006-12-13 10:07:33'),(264,NULL,20,'DataElement','Create','Treatment Group',' Create of RangeElement with with 20',NULL,'2006-12-13 10:08:30'),(265,NULL,20,'DataElement','Update','Treatment Group',' Update of RangeElement with with 20',NULL,'2006-12-13 10:10:22'),(266,NULL,20,'DataElement','Update','Treatment Group ID',' Update of RangeElement with with 20',NULL,'2006-12-13 10:10:58'),(267,NULL,58,'ParameterType','Destroy','Age',' Destroy of ParameterType with with 58',NULL,'2006-12-13 10:12:52'),(268,NULL,57,'ParameterType','Destroy','Weight',' Destroy of ParameterType with with 57',NULL,'2006-12-13 10:12:54'),(269,NULL,56,'ParameterType','Destroy','Dose Volume',' Destroy of ParameterType with with 56',NULL,'2006-12-13 10:12:57'),(270,NULL,55,'ParameterType','Destroy','Sex',' Destroy of ParameterType with with 55',NULL,'2006-12-13 10:13:00'),(271,NULL,59,'ParameterType','Create','Phenotype',' Create of ParameterType with with 59',NULL,'2006-12-13 10:13:41'),(272,NULL,59,'ParameterType','Update','Measurements',' Update of ParameterType with with 59',NULL,'2006-12-13 10:14:08'),(273,NULL,60,'ParameterType','Create','Counts',' Create of ParameterType with with 60',NULL,'2006-12-13 10:14:32'),(274,NULL,7,'ParameterType','Update','Time',' Update of ParameterType with with 7',NULL,'2006-12-13 10:14:50'),(275,NULL,61,'ParameterType','Create','Stats',' Create of ParameterType with with 61',NULL,'2006-12-13 10:17:32'),(276,NULL,62,'ParameterType','Create','Container',' Create of ParameterType with with 62',NULL,'2006-12-13 10:18:22'),(277,NULL,63,'ParameterType','Create','Group',' Create of ParameterType with with 63',NULL,'2006-12-13 11:10:45'),(278,NULL,64,'ParameterType','Create','Animal Id',' Create of ParameterType with with 64',NULL,'2006-12-13 11:12:11'),(279,NULL,64,'ParameterType','Destroy','Animal Id',' Destroy of ParameterType with with 64',NULL,'2006-12-13 11:13:20'),(280,NULL,63,'ParameterType','Destroy','Group',' Destroy of ParameterType with with 63',NULL,'2006-12-13 11:13:32'),(281,NULL,65,'ParameterType','Create','ID',' Create of ParameterType with with 65',NULL,'2006-12-13 11:13:45'),(282,NULL,66,'ParameterType','Create','Sex',' Create of ParameterType with with 66',NULL,'2006-12-13 11:18:08'),(283,NULL,67,'ParameterType','Create','Size',' Create of ParameterType with with 67',NULL,'2006-12-13 11:30:59'),(284,NULL,1,'ParameterRole','Update','observation',' Update of ParameterRole with with 1',NULL,'2006-12-13 16:43:21'),(285,NULL,2,'ParameterRole','Update','result',' Update of ParameterRole with with 2',NULL,'2006-12-13 16:43:32'),(286,NULL,3,'ParameterRole','Update','setting',' Update of ParameterRole with with 3',NULL,'2006-12-13 16:43:39'),(287,NULL,4,'ParameterRole','Update','subject',' Update of ParameterRole with with 4',NULL,'2006-12-13 16:43:47'),(288,NULL,5,'ParameterRole','Update','publish',' Update of ParameterRole with with 5',NULL,'2006-12-13 16:43:53'),(289,NULL,6,'ParameterRole','Update','condition',' Update of ParameterRole with with 6',NULL,'2006-12-13 16:44:00'),(290,NULL,1,'DataType','Update','text',' Update of DataType with with 1',NULL,'2006-12-13 16:44:12'),(291,NULL,2,'DataType','Update','numeric',' Update of DataType with with 2',NULL,'2006-12-13 16:44:21'),(292,NULL,3,'DataType','Update','date',' Update of DataType with with 3',NULL,'2006-12-13 16:44:28'),(293,NULL,4,'DataType','Update','time',' Update of DataType with with 4',NULL,'2006-12-13 16:44:35'),(294,NULL,5,'DataType','Update','lookup',' Update of DataType with with 5',NULL,'2006-12-13 16:44:41'),(295,NULL,6,'DataType','Update','url',' Update of DataType with with 6',NULL,'2006-12-13 16:44:50'),(296,NULL,7,'DataType','Update','file',' Update of DataType with with 7',NULL,'2006-12-13 16:45:26'),(297,NULL,53,'ParameterType','Update','Factor',' Update of ParameterType with with 53',NULL,'2006-12-13 19:03:21'),(298,NULL,59,'ParameterType','Update','Phenotype',' Update of ParameterType with with 59',NULL,'2006-12-13 19:06:27'),(299,NULL,66,'ParameterType','Destroy','Sex',' Destroy of ParameterType with with 66',NULL,'2006-12-13 19:10:36'),(300,NULL,5,'ParameterType','Update','Inhib',' Update of ParameterType with with 5',NULL,'2006-12-13 19:37:47'),(301,NULL,6,'ParameterRole','Update','condition',' Update of ParameterRole with with 6',NULL,'2006-12-13 19:38:06'),(302,NULL,5,'ParameterRole','Destroy','publish',' Destroy of ParameterRole with with 5',NULL,'2006-12-13 19:38:14'),(303,NULL,9,'StudyStage','Destroy','Publication',' Destroy of StudyStage with with 9',NULL,'2006-12-13 19:38:29'),(304,NULL,7,'StudyStage','Destroy','QC',' Destroy of StudyStage with with 7',NULL,'2006-12-13 19:38:33'),(305,NULL,68,'ParameterType','Create','File',' Create of ParameterType with with 68',NULL,'2006-12-13 20:45:43'),(306,NULL,17,'DataElement','Destroy','Role',' Destroy of ListElement with with 17',NULL,'2006-12-14 09:04:56'),(307,NULL,72,'DataConcept','Destroy','Subject Role',' Destroy of DataConcept with with 72',NULL,'2006-12-14 09:04:56'),(308,NULL,7,'ParameterRole','Create','note',' Create of ParameterRole with with 7',NULL,'2006-12-14 10:36:19'),(309,NULL,61,'ParameterType','Update','Derived',' Update of ParameterType with with 61',NULL,'2006-12-14 10:38:55'),(310,NULL,8,'ParameterType','Update','Compound',' Update of ParameterType with with 8',NULL,'2006-12-14 10:45:57'),(311,NULL,69,'ParameterType','Create','Genotype',' Create of ParameterType with with 69',NULL,'2006-12-14 10:51:18'),(312,NULL,70,'ParameterType','Create','Date',' Create of ParameterType with with 70',NULL,'2006-12-16 10:49:35'),(313,NULL,21,'DataElement','Create','Role',' Create of ListElement with with 21',NULL,'2006-12-16 11:12:20'),(314,NULL,21,'DataElement','Update','Role',' Update of ListElement with with 21',NULL,'2006-12-16 18:29:09'),(315,NULL,21,'DataElement','Update','Role',' Update of ListElement with with 21',NULL,'2006-12-16 18:32:27'),(316,NULL,22,'DataElement','Create','Compound Role',' Create of DataElement with with 22',NULL,'2006-12-16 18:47:36'),(317,NULL,22,'DataElement','Update','Compound Role',' Update of DataElement with with 22',NULL,'2006-12-16 18:53:52'),(318,NULL,23,'DataElement','Create','posctrl',' Create of DataElement with with 23',NULL,'2006-12-16 18:55:00'),(319,NULL,24,'DataElement','Create','negctrl',' Create of DataElement with with 24',NULL,'2006-12-16 18:55:53'),(320,NULL,25,'DataElement','Create','vehicle',' Create of DataElement with with 25',NULL,'2006-12-16 18:56:12'),(321,NULL,26,'DataElement','Create','subject',' Create of DataElement with with 26',NULL,'2006-12-16 18:56:25'),(322,NULL,27,'DataElement','Create','CompoundRole',' Create of DataElement with with 27',NULL,'2006-12-16 18:59:32'),(323,NULL,28,'DataElement','Create','posctrl',' Create of DataElement with with 28',NULL,'2006-12-16 19:00:08'),(324,NULL,29,'DataElement','Create','negctrl',' Create of DataElement with with 29',NULL,'2006-12-16 19:00:26'),(325,NULL,30,'DataElement','Create','subject',' Create of DataElement with with 30',NULL,'2006-12-16 19:00:44'),(326,NULL,31,'DataElement','Create','ref',' Create of DataElement with with 31',NULL,'2006-12-16 19:01:02'),(327,NULL,32,'DataElement','Create','standard',' Create of DataElement with with 32',NULL,'2006-12-16 19:01:20'),(328,NULL,33,'DataElement','Create','vehicle',' Create of DataElement with with 33',NULL,'2006-12-16 19:01:35'),(329,NULL,51,'ParameterType','Update','Role',' Update of ParameterType with with 51',NULL,'2006-12-16 19:02:33'),(330,NULL,51,'ParameterType','Update','Role',' Update of ParameterType with with 51',NULL,'2006-12-16 19:03:02'),(331,NULL,51,'ParameterType','Update','Role',' Update of ParameterType with with 51',NULL,'2006-12-16 19:04:28'),(332,NULL,34,'DataElement','Create','RouteOfAdmin',' Create of DataElement with with 34',NULL,'2006-12-16 19:14:25'),(333,NULL,35,'DataElement','Create','sc',' Create of DataElement with with 35',NULL,'2006-12-16 19:15:46'),(334,NULL,36,'DataElement','Create','po',' Create of DataElement with with 36',NULL,'2006-12-16 19:15:59'),(335,NULL,37,'DataElement','Create','im',' Create of DataElement with with 37',NULL,'2006-12-16 19:16:20'),(336,NULL,38,'DataElement','Create','ip',' Create of DataElement with with 38',NULL,'2006-12-16 19:16:40'),(337,NULL,39,'DataElement','Create','iv',' Create of DataElement with with 39',NULL,'2006-12-16 19:16:57'),(338,NULL,40,'DataElement','Create','roa',' Create of ListElement with with 40',NULL,'2006-12-16 19:44:52'),(339,NULL,41,'DataElement','Create','R-O-A',' Create of ListElement with with 41',NULL,'2006-12-16 19:46:10'),(340,NULL,54,'ParameterType','Update','Route',' Update of ParameterType with with 54',NULL,'2006-12-18 09:44:53'),(341,NULL,42,'DataElement','Create','Behaviour Score',' Create of ListElement with with 42',NULL,'2006-12-19 13:29:20'),(342,NULL,71,'ParameterType','Create','Score',' Create of ParameterType with with 71',NULL,'2006-12-19 13:33:08'),(343,NULL,20,'DataElement','Update','Treatment Group ID',' Update of RangeElement with with 20',NULL,'2006-12-19 14:56:24'),(344,NULL,20,'DataElement','Update','Treatment Group ID',' Update of RangeElement with with 20',NULL,'2006-12-19 14:56:54'),(345,NULL,2,'DataContext','Update','LegacyHTS',' Update of DataContext with with 2',NULL,'2007-01-03 19:55:49'),(346,NULL,1,'DataSystem','Update','Internal',' Update of DataSystem with with 1',NULL,'2007-01-10 11:16:31'),(347,NULL,29,'DataConcept','Update','DataFormat',' Update of DataConcept with with 29',NULL,'2007-01-12 13:58:05'),(348,NULL,1,'DataSystem','Update','Internal',' Update of DataSystem with with 1',NULL,'2007-01-13 21:46:14'),(349,NULL,7,'DataConcept','Update','Container',' Update of DataConcept with with 7',NULL,'2007-01-19 15:37:11'),(350,NULL,43,'DataElement','Create','ALCES',' Create of DataElement with with 43',NULL,'2007-01-19 15:47:37'),(351,NULL,7,'DataElement','Destroy','Test',' Destroy of ModelElement with with 7',NULL,'2007-01-19 15:58:27'),(352,NULL,43,'DataElement','Destroy','ALCES',' Destroy of DataElement with with 43',NULL,'2007-01-19 16:00:11'),(353,NULL,41,'DataElement','Destroy','R-O-A',' Destroy of ListElement with with 41',NULL,'2007-01-19 16:00:17'),(354,NULL,40,'DataElement','Destroy','roa',' Destroy of ListElement with with 40',NULL,'2007-01-19 16:00:23'),(355,NULL,37,'DataElement','Destroy','im',' Destroy of DataElement with with 37',NULL,'2007-01-19 16:00:28'),(356,NULL,38,'DataElement','Destroy','ip',' Destroy of DataElement with with 38',NULL,'2007-01-19 16:00:28'),(357,NULL,39,'DataElement','Destroy','iv',' Destroy of DataElement with with 39',NULL,'2007-01-19 16:00:28'),(358,NULL,36,'DataElement','Destroy','po',' Destroy of DataElement with with 36',NULL,'2007-01-19 16:00:28'),(359,NULL,35,'DataElement','Destroy','sc',' Destroy of DataElement with with 35',NULL,'2007-01-19 16:00:28'),(360,NULL,34,'DataElement','Destroy','RouteOfAdmin',' Destroy of DataElement with with 34',NULL,'2007-01-19 16:00:28'),(361,NULL,24,'DataElement','Destroy','negctrl',' Destroy of DataElement with with 24',NULL,'2007-01-19 16:00:33'),(362,NULL,23,'DataElement','Destroy','posctrl',' Destroy of DataElement with with 23',NULL,'2007-01-19 16:00:33'),(363,NULL,26,'DataElement','Destroy','subject',' Destroy of DataElement with with 26',NULL,'2007-01-19 16:00:33'),(364,NULL,25,'DataElement','Destroy','vehicle',' Destroy of DataElement with with 25',NULL,'2007-01-19 16:00:33'),(365,NULL,22,'DataElement','Destroy','Compound Role',' Destroy of DataElement with with 22',NULL,'2007-01-19 16:00:33'),(366,NULL,20,'DataElement','Destroy','Treatment Group ID',' Destroy of RangeElement with with 20',NULL,'2007-01-19 16:00:44'),(367,NULL,13,'DataElement','Destroy','sexs',' Destroy of ListElement with with 13',NULL,'2007-01-19 16:00:56'),(368,NULL,5,'DataElement','Destroy','A',' Destroy of DataElement with with 5',NULL,'2007-01-19 16:01:01'),(369,NULL,6,'DataElement','Destroy','B',' Destroy of DataElement with with 6',NULL,'2007-01-19 16:01:01'),(370,NULL,4,'DataElement','Destroy','Rack',' Destroy of DataElement with with 4',NULL,'2007-01-19 16:01:01'),(371,NULL,3,'DataElement','Destroy','Wells96',' Destroy of RangeElement with with 3',NULL,'2007-01-19 16:01:11'),(372,NULL,16,'DataElement','Destroy','more_studies2',' Destroy of SqlElement with with 16',NULL,'2007-01-19 16:01:23'),(373,NULL,14,'DataElement','Destroy','Local_Studies',' Destroy of SqlElement with with 14',NULL,'2007-01-19 16:01:28'),(374,NULL,10,'DataElement','Destroy','DataType',' Destroy of ModelElement with with 10',NULL,'2007-01-19 16:01:36'),(375,NULL,11,'DataElement','Destroy','Controls',' Destroy of ListElement with with 11',NULL,'2007-01-19 16:01:40'),(376,NULL,9,'DataElement','Destroy','Format',' Destroy of RangeElement with with 9',NULL,'2007-01-19 16:01:46'),(377,NULL,18,'DataElement','Destroy','Rout of Admin',' Destroy of ListElement with with 18',NULL,'2007-01-19 16:02:31'),(378,NULL,38,'DataConcept','Destroy','1',' Destroy of DataConcept with with 38',NULL,'2007-01-19 16:02:31'),(379,NULL,36,'DataConcept','Destroy','Route',' Destroy of DataConcept with with 36',NULL,'2007-01-19 16:02:31'),(380,NULL,42,'DataElement','Destroy','Behaviour Score',' Destroy of ListElement with with 42',NULL,'2007-01-19 16:03:11'),(381,NULL,37,'DataConcept','Destroy','Score',' Destroy of DataConcept with with 37',NULL,'2007-01-19 16:03:11'),(382,NULL,21,'DataElement','Destroy','Role',' Destroy of ListElement with with 21',NULL,'2007-01-19 16:03:32'),(383,NULL,29,'DataElement','Destroy','negctrl',' Destroy of DataElement with with 29',NULL,'2007-01-19 16:03:33'),(384,NULL,28,'DataElement','Destroy','posctrl',' Destroy of DataElement with with 28',NULL,'2007-01-19 16:03:33'),(385,NULL,31,'DataElement','Destroy','ref',' Destroy of DataElement with with 31',NULL,'2007-01-19 16:03:33'),(386,NULL,32,'DataElement','Destroy','standard',' Destroy of DataElement with with 32',NULL,'2007-01-19 16:03:33'),(387,NULL,30,'DataElement','Destroy','subject',' Destroy of DataElement with with 30',NULL,'2007-01-19 16:03:33'),(388,NULL,33,'DataElement','Destroy','vehicle',' Destroy of DataElement with with 33',NULL,'2007-01-19 16:03:33'),(389,NULL,27,'DataElement','Destroy','CompoundRole',' Destroy of DataElement with with 27',NULL,'2007-01-19 16:03:33'),(390,NULL,28,'DataElement','Destroy','posctrl',' Destroy of DataElement with with 28',NULL,'2007-01-19 16:03:33'),(391,NULL,29,'DataElement','Destroy','negctrl',' Destroy of DataElement with with 29',NULL,'2007-01-19 16:03:33'),(392,NULL,30,'DataElement','Destroy','subject',' Destroy of DataElement with with 30',NULL,'2007-01-19 16:03:33'),(393,NULL,31,'DataElement','Destroy','ref',' Destroy of DataElement with with 31',NULL,'2007-01-19 16:03:33'),(394,NULL,32,'DataElement','Destroy','standard',' Destroy of DataElement with with 32',NULL,'2007-01-19 16:03:33'),(395,NULL,33,'DataElement','Destroy','vehicle',' Destroy of DataElement with with 33',NULL,'2007-01-19 16:03:33'),(396,NULL,19,'DataElement','Destroy','Sex',' Destroy of ListElement with with 19',NULL,'2007-01-19 16:03:33'),(397,NULL,35,'DataConcept','Destroy','Sex',' Destroy of DataConcept with with 35',NULL,'2007-01-19 16:03:33'),(398,NULL,34,'DataConcept','Destroy','Lookup',' Destroy of DataConcept with with 34',NULL,'2007-01-19 16:03:33'),(399,NULL,39,'DataConcept','Create','Lookup',' Create of DataConcept with with 39',NULL,'2007-01-19 16:04:03'),(400,NULL,44,'DataElement','Create','Route',' Create of ListElement with with 44',NULL,'2007-01-19 16:06:29'),(401,NULL,45,'DataElement','Create','Studies',' Create of ModelElement with with 45',NULL,'2007-01-19 16:08:38'),(402,NULL,46,'DataElement','Create','Requests',' Create of ModelElement with with 46',NULL,'2007-01-19 16:09:48'),(403,NULL,0,'DataConcept','Create','BioRails',' Create of DataConcept with with 0',NULL,'2007-01-22 15:23:29'),(404,NULL,40,'DataConcept','Create','Numeric',' Create of DataConcept with with 40',NULL,'2007-01-22 17:47:31'),(405,NULL,40,'DataConcept','Update','Numeric',' Update of DataConcept with with 40',NULL,'2007-01-22 17:47:31'),(406,NULL,41,'DataConcept','Create','Textual',' Create of DataConcept with with 41',NULL,'2007-01-22 21:24:33'),(407,NULL,41,'DataConcept','Update','Textual',' Update of DataConcept with with 41',NULL,'2007-01-22 21:24:33'),(408,NULL,28,'DataConcept','Update','DataType',' Update of DataConcept with with 28',NULL,'2007-01-22 21:42:57'),(409,NULL,28,'DataConcept','Update','DataType',' Update of DataConcept with with 28',NULL,'2007-01-22 21:43:56'),(410,NULL,42,'DataConcept','Create','xxxx',' Create of DataConcept with with 42',NULL,'2007-01-22 21:58:57'),(411,NULL,42,'DataConcept','Update','xxxx',' Update of DataConcept with with 42',NULL,'2007-01-22 21:58:57'),(412,NULL,42,'DataConcept','Destroy','xxxx',' Destroy of DataConcept with with 42',NULL,'2007-01-22 22:10:04'),(413,NULL,41,'DataConcept','Destroy','Textual',' Destroy of DataConcept with with 41',NULL,'2007-01-22 22:10:09'),(414,NULL,40,'DataConcept','Destroy','Numeric',' Destroy of DataConcept with with 40',NULL,'2007-01-22 22:10:13'),(415,NULL,28,'DataConcept','Update','DataType',' Update of DataConcept with with 28',NULL,'2007-01-22 23:32:32'),(416,NULL,43,'DataConcept','Create','Development',' Create of DataConcept with with 43',NULL,'2007-01-22 23:34:15'),(417,NULL,43,'DataConcept','Update','Development',' Update of DataConcept with with 43',NULL,'2007-01-22 23:34:15'),(418,NULL,44,'DataConcept','Create','Screening',' Create of DataConcept with with 44',NULL,'2007-01-22 23:34:34'),(419,NULL,44,'DataConcept','Update','Screening',' Update of DataConcept with with 44',NULL,'2007-01-22 23:34:34'),(420,NULL,47,'DataElement','Create','Protocol',' Create of ModelElement with with 47',NULL,'2007-01-22 23:40:33'),(421,NULL,47,'DataElement','Destroy','Protocol',' Destroy of ModelElement with with 47',NULL,'2007-01-22 23:41:46'),(422,NULL,44,'DataConcept','Destroy','Screening',' Destroy of DataConcept with with 44',NULL,'2007-01-22 23:44:17'),(423,NULL,43,'DataConcept','Destroy','Development',' Destroy of DataConcept with with 43',NULL,'2007-01-22 23:44:21'),(424,NULL,1,'DataConcept','Update','BioRails',' Update of DataContext with with 1',NULL,'2007-01-22 23:55:23'),(425,NULL,1,'DataConcept','Update','BioRails',' Update of DataContext with with 1',NULL,'2007-01-22 23:56:55'),(426,NULL,10,'ParameterType','Update','Plate',' Update of ParameterType with with 10',NULL,'2007-01-23 09:06:19'),(427,NULL,62,'ParameterType','Update','Container',' Update of ParameterType with with 62',NULL,'2007-01-23 09:15:30'),(428,NULL,48,'DataElement','Create','Plates',' Create of SqlElement with with 48',NULL,'2007-01-23 09:21:03'),(429,NULL,49,'DataElement','Create','COmpounds',' Create of SqlElement with with 49',NULL,'2007-01-23 09:22:24'),(430,NULL,1,'DataConcept','Update','BioRails',' Update of DataContext with with 1',NULL,'2007-01-23 20:54:17'),(431,NULL,50,'DataElement','Create','Species',' Create of DataElement with with 50',NULL,'2007-01-31 13:31:47'),(432,NULL,40,'DataConcept','Create','Species',' Create of DataConcept with with 40',NULL,'2007-01-31 13:33:18'),(433,NULL,40,'DataConcept','Update','Species',' Update of DataConcept with with 40',NULL,'2007-01-31 13:33:18'),(434,NULL,50,'DataElement','Destroy','Species',' Destroy of DataElement with with 50',NULL,'2007-01-31 13:33:35'),(435,NULL,41,'DataConcept','Create','Mouse',' Create of DataConcept with with 41',NULL,'2007-01-31 13:34:27'),(436,NULL,41,'DataConcept','Update','Mouse',' Update of DataConcept with with 41',NULL,'2007-01-31 13:34:27'),(437,NULL,42,'DataConcept','Create','Rattus rattus',' Create of DataConcept with with 42',NULL,'2007-01-31 13:35:00'),(438,NULL,42,'DataConcept','Update','Rattus rattus',' Update of DataConcept with with 42',NULL,'2007-01-31 13:35:00'),(439,NULL,43,'DataConcept','Create','Guinea pig',' Create of DataConcept with with 43',NULL,'2007-01-31 13:36:27'),(440,NULL,43,'DataConcept','Update','Guinea pig',' Update of DataConcept with with 43',NULL,'2007-01-31 13:36:27'),(441,NULL,44,'DataConcept','Create','Moose',' Create of DataConcept with with 44',NULL,'2007-01-31 13:36:51'),(442,NULL,44,'DataConcept','Update','Moose',' Update of DataConcept with with 44',NULL,'2007-01-31 13:36:51'),(443,NULL,44,'DataElement','Destroy','Route',' Destroy of ListElement with with 44',NULL,'2007-01-31 13:37:51'),(444,NULL,45,'DataConcept','Create','Route',' Create of DataConcept with with 45',NULL,'2007-01-31 13:38:16'),(445,NULL,45,'DataConcept','Update','Route',' Update of DataConcept with with 45',NULL,'2007-01-31 13:38:16'),(446,NULL,42,'DataConcept','Destroy','Rattus rattus',' Destroy of DataConcept with with 42',NULL,'2007-01-31 13:39:10'),(447,NULL,41,'DataConcept','Destroy','Mouse',' Destroy of DataConcept with with 41',NULL,'2007-01-31 13:39:19'),(448,NULL,44,'DataConcept','Destroy','Moose',' Destroy of DataConcept with with 44',NULL,'2007-01-31 13:39:29'),(449,NULL,43,'DataConcept','Destroy','Guinea pig',' Destroy of DataConcept with with 43',NULL,'2007-01-31 13:39:46'),(450,NULL,40,'DataConcept','Destroy','Species',' Destroy of DataConcept with with 40',NULL,'2007-01-31 13:41:30'),(451,NULL,45,'DataConcept','Destroy','Route',' Destroy of DataConcept with with 45',NULL,'2007-01-31 13:41:38'),(452,NULL,51,'DataElement','Create','Route of Admin',' Create of DataElement with with 51',NULL,'2007-01-31 13:42:09'),(453,NULL,51,'DataElement','Destroy','Route of Admin',' Destroy of DataElement with with 51',NULL,'2007-01-31 13:42:45'),(454,NULL,46,'DataConcept','Create','Route of Administation',' Create of DataConcept with with 46',NULL,'2007-01-31 13:43:12'),(455,NULL,46,'DataConcept','Update','Route of Administation',' Update of DataConcept with with 46',NULL,'2007-01-31 13:43:12'),(456,NULL,52,'DataElement','Create','Rat',' Create of DataElement with with 52',NULL,'2007-01-31 13:43:50'),(457,NULL,53,'DataElement','Create','Mouse',' Create of DataElement with with 53',NULL,'2007-01-31 13:44:14'),(458,NULL,54,'DataElement','Create','Guinea Pig',' Create of DataElement with with 54',NULL,'2007-01-31 13:45:09'),(459,NULL,55,'DataElement','Create','Moose',' Create of DataElement with with 55',NULL,'2007-01-31 13:45:38'),(460,NULL,55,'DataElement','Destroy','Moose',' Destroy of DataElement with with 55',NULL,'2007-01-31 13:46:27'),(461,NULL,54,'DataElement','Destroy','Guinea Pig',' Destroy of DataElement with with 54',NULL,'2007-01-31 13:46:38'),(462,NULL,53,'DataElement','Destroy','Mouse',' Destroy of DataElement with with 53',NULL,'2007-01-31 13:46:48'),(463,NULL,52,'DataElement','Destroy','Rat',' Destroy of DataElement with with 52',NULL,'2007-01-31 13:46:58'),(464,NULL,56,'DataElement','Create','Route of Administration',' Create of ListElement with with 56',NULL,'2007-01-31 13:48:35'),(465,NULL,46,'DataConcept','Destroy','Route of Administation',' Destroy of DataConcept with with 46',NULL,'2007-01-31 13:49:00'),(466,NULL,57,'DataElement','Create','Sex',' Create of ListElement with with 57',NULL,'2007-01-31 13:49:55'),(467,NULL,47,'DataConcept','Create','mammals',' Create of DataConcept with with 47',NULL,'2007-01-31 13:51:33'),(468,NULL,47,'DataConcept','Update','mammals',' Update of DataConcept with with 47',NULL,'2007-01-31 13:51:33'),(469,NULL,47,'DataConcept','Update','Mammals',' Update of DataConcept with with 47',NULL,'2007-01-31 13:51:54'),(470,NULL,58,'DataElement','Create','Rat',' Create of DataElement with with 58',NULL,'2007-01-31 13:53:34'),(471,NULL,59,'DataElement','Create','Mouse',' Create of DataElement with with 59',NULL,'2007-01-31 13:53:58'),(472,NULL,60,'DataElement','Create','Guinea Pig',' Create of DataElement with with 60',NULL,'2007-01-31 13:54:44'),(473,NULL,61,'DataElement','Create','Moose',' Create of DataElement with with 61',NULL,'2007-01-31 13:55:10'),(474,NULL,69,'ParameterType','Update','Genotype',' Update of ParameterType with with 69',NULL,'2007-01-31 14:08:47'),(475,NULL,54,'ParameterType','Update','Route',' Update of ParameterType with with 54',NULL,'2007-01-31 14:10:26'),(476,NULL,54,'ParameterType','Update','Route',' Update of ParameterType with with 54',NULL,'2007-01-31 14:11:30'),(477,NULL,69,'ParameterType','Update','Genotype',' Update of ParameterType with with 69',NULL,'2007-01-31 14:17:54'),(478,NULL,69,'ParameterType','Update','Genotype',' Update of ParameterType with with 69',NULL,'2007-01-31 14:26:57'),(479,NULL,61,'DataElement','Destroy','Moose',' Destroy of DataElement with with 61',NULL,'2007-01-31 14:30:03'),(480,NULL,60,'DataElement','Destroy','Guinea Pig',' Destroy of DataElement with with 60',NULL,'2007-01-31 14:30:13'),(481,NULL,59,'DataElement','Destroy','Mouse',' Destroy of DataElement with with 59',NULL,'2007-01-31 14:30:35'),(482,NULL,58,'DataElement','Destroy','Rat',' Destroy of DataElement with with 58',NULL,'2007-01-31 14:30:46'),(483,NULL,62,'DataElement','Create','Small',' Create of ListElement with with 62',NULL,'2007-01-31 14:33:28'),(484,NULL,62,'DataElement','Destroy','Small',' Destroy of ListElement with with 62',NULL,'2007-01-31 14:33:57'),(485,NULL,63,'DataElement','Create','Small',' Create of ListElement with with 63',NULL,'2007-01-31 14:35:09'),(486,NULL,69,'ParameterType','Update','Genotype',' Update of ParameterType with with 69',NULL,'2007-01-31 14:35:31'),(487,NULL,72,'ParameterType','Create','Stats',' Create of ParameterType with with 72',NULL,'2007-01-31 14:40:54'),(488,NULL,73,'ParameterType','Create','Sex',' Create of ParameterType with with 73',NULL,'2007-01-31 20:29:19'),(489,NULL,64,'DataElement','Create','serum species ',' Create of ListElement with with 64',NULL,'2007-02-06 09:47:13'),(490,NULL,69,'ParameterType','Update','Genotype',' Update of ParameterType with with 69',NULL,'2007-02-06 10:14:43'),(491,NULL,6,'ParameterType','Update','Concentration',' Update of ParameterType with with 6',NULL,'2007-02-06 10:19:37'),(492,NULL,65,'DataElement','Create','Eliza Treatments',' Create of ListElement with with 65',NULL,'2007-02-06 10:28:45'),(493,NULL,74,'ParameterType','Create','Treatment',' Create of ParameterType with with 74',NULL,'2007-02-06 10:30:47'),(494,NULL,74,'ParameterType','Update','Eliza Treatment',' Update of ParameterType with with 74',NULL,'2007-02-06 10:31:31'),(495,NULL,3,'ParameterType','Update','Absorbance',' Update of ParameterType with with 3',NULL,'2007-02-06 10:46:44'),(496,NULL,5,'ParameterType','Update','Inhibition',' Update of ParameterType with with 5',NULL,'2007-02-06 10:48:28'),(497,NULL,4,'DataFormat','Update','Double',' Update of DataFormat with with 4',NULL,'2007-02-07 14:10:16'),(498,NULL,1,'DataFormat','Update','Text',' Update of DataFormat with with 1',NULL,'2007-02-07 14:10:25'),(499,NULL,8,'DataFormat','Update','Integer',' Update of DataFormat with with 8',NULL,'2007-02-07 14:10:37'),(500,NULL,4,'DataFormat','Update','Double',' Update of DataFormat with with 4',NULL,'2007-02-07 21:42:48'),(501,NULL,66,'DataElement','Create','Protocol',' Create of ModelElement with with 66',NULL,'2007-02-28 12:17:59'),(502,NULL,48,'DataConcept','Create','Users',' Create of DataConcept with with 48',NULL,'2007-02-28 17:55:48'),(503,NULL,48,'DataConcept','Update','Users',' Update of DataConcept with with 48',NULL,'2007-02-28 17:55:48'),(504,NULL,67,'DataElement','Create','Users',' Create of ModelElement with with 67',NULL,'2007-02-28 17:56:19'),(505,NULL,68,'DataElement','Create','ParameterType',' Create of ModelElement with with 68',NULL,'2007-02-28 17:56:41'),(506,NULL,68,'DataElement','Destroy','ParameterType',' Destroy of ModelElement with with 68',NULL,'2007-02-28 17:56:47'),(507,NULL,69,'DataElement','Create','ParameterRoles',' Create of ModelElement with with 69',NULL,'2007-02-28 17:57:47'),(508,NULL,70,'DataElement','Create','ParameterTypes',' Create of ModelElement with with 70',NULL,'2007-02-28 17:58:07'),(509,NULL,21,'DataConcept','Destroy','Invivo',' Destroy of DataConcept with with 21',NULL,'2007-02-28 17:58:17'),(510,NULL,22,'DataConcept','Destroy','Invitro',' Destroy of DataConcept with with 22',NULL,'2007-02-28 17:58:18'),(511,NULL,71,'DataElement','Create','Compounds',' Create of ModelElement with with 71',NULL,'2007-02-28 17:58:55'),(512,NULL,72,'DataElement','Create','Tasks',' Create of ModelElement with with 72',NULL,'2007-02-28 17:59:15'),(513,NULL,73,'DataElement','Create','Times',' Create of ListElement with with 73',NULL,'2007-02-28 17:59:43'),(514,NULL,74,'DataElement','Create','hours',' Create of ListElement with with 74',NULL,'2007-02-28 18:00:43'),(515,NULL,75,'DataElement','Create','Concentration',' Create of ListElement with with 75',NULL,'2007-02-28 18:17:28'),(516,NULL,76,'DataElement','Create','Compound Role',' Create of ListElement with with 76',NULL,'2007-03-08 06:58:48'),(517,NULL,51,'ParameterType','Update','Role',' Update of ParameterType with with 51',NULL,'2007-03-08 07:00:39'),(518,NULL,75,'ParameterType','Create','Properties',' Create of ParameterType with with 75',NULL,'2007-03-08 07:01:31'),(519,NULL,76,'ParameterType','Create','Descriptors',' Create of ParameterType with with 76',NULL,'2007-03-08 07:01:41'),(520,NULL,77,'DataElement','Create','Score',' Create of ListElement with with 77',NULL,'2007-03-08 07:06:52'),(521,NULL,71,'ParameterType','Update','Score',' Update of ParameterType with with 71',NULL,'2007-03-08 07:07:20'),(522,NULL,77,'DataElement','Update','Score',' Update of ListElement with with 77',NULL,'2007-03-08 07:07:50'),(523,NULL,1,'ParameterType','Destroy','XC50',' Destroy of ParameterType with with 1',NULL,'2007-03-20 11:52:43'),(524,NULL,2,'ParameterType','Destroy','KI',' Destroy of ParameterType with with 2',NULL,'2007-03-20 11:52:52'),(525,NULL,3,'ParameterType','Destroy','Absorbance',' Destroy of ParameterType with with 3',NULL,'2007-03-20 11:52:56'),(526,NULL,4,'ParameterType','Destroy','Dose',' Destroy of ParameterType with with 4',NULL,'2007-03-20 11:52:59'),(527,NULL,5,'ParameterType','Destroy','Inhibition',' Destroy of ParameterType with with 5',NULL,'2007-03-20 11:53:02'),(528,NULL,6,'ParameterType','Destroy','Concentration',' Destroy of ParameterType with with 6',NULL,'2007-03-20 11:53:04'),(529,NULL,7,'ParameterType','Destroy','Time',' Destroy of ParameterType with with 7',NULL,'2007-03-20 11:53:07'),(530,NULL,8,'ParameterType','Destroy','Compound',' Destroy of ParameterType with with 8',NULL,'2007-03-20 11:53:11'),(531,NULL,9,'ParameterType','Destroy','Batch',' Destroy of ParameterType with with 9',NULL,'2007-03-20 11:53:14'),(532,NULL,10,'ParameterType','Destroy','Plate',' Destroy of ParameterType with with 10',NULL,'2007-03-20 11:53:17'),(533,NULL,11,'ParameterType','Destroy','Well',' Destroy of ParameterType with with 11',NULL,'2007-03-20 11:53:19'),(534,NULL,12,'ParameterType','Destroy','Sample',' Destroy of ParameterType with with 12',NULL,'2007-03-20 11:53:22'),(535,NULL,13,'ParameterType','Destroy','Birth',' Destroy of ParameterType with with 13',NULL,'2007-03-20 11:53:25'),(536,NULL,14,'ParameterType','Destroy','Comment',' Destroy of ParameterType with with 14',NULL,'2007-03-20 11:53:28'),(537,NULL,51,'ParameterType','Destroy','Role',' Destroy of ParameterType with with 51',NULL,'2007-03-20 11:53:32'),(538,NULL,52,'ParameterType','Destroy','Activity',' Destroy of ParameterType with with 52',NULL,'2007-03-20 11:53:34'),(539,NULL,53,'ParameterType','Destroy','Factor',' Destroy of ParameterType with with 53',NULL,'2007-03-20 11:53:37'),(540,NULL,54,'ParameterType','Destroy','Route',' Destroy of ParameterType with with 54',NULL,'2007-03-20 11:53:40'),(541,NULL,59,'ParameterType','Destroy','Phenotype',' Destroy of ParameterType with with 59',NULL,'2007-03-20 11:53:42'),(542,NULL,60,'ParameterType','Destroy','Counts',' Destroy of ParameterType with with 60',NULL,'2007-03-20 11:53:45'),(543,NULL,61,'ParameterType','Destroy','Derived',' Destroy of ParameterType with with 61',NULL,'2007-03-20 11:53:47'),(544,NULL,62,'ParameterType','Destroy','Container',' Destroy of ParameterType with with 62',NULL,'2007-03-20 11:53:50'),(545,NULL,65,'ParameterType','Destroy','ID',' Destroy of ParameterType with with 65',NULL,'2007-03-20 11:53:53'),(546,NULL,67,'ParameterType','Destroy','Size',' Destroy of ParameterType with with 67',NULL,'2007-03-20 11:53:55'),(547,NULL,68,'ParameterType','Destroy','File',' Destroy of ParameterType with with 68',NULL,'2007-03-20 11:53:59'),(548,NULL,69,'ParameterType','Destroy','Genotype',' Destroy of ParameterType with with 69',NULL,'2007-03-20 11:54:04'),(549,NULL,70,'ParameterType','Destroy','Date',' Destroy of ParameterType with with 70',NULL,'2007-03-20 11:54:07'),(550,NULL,71,'ParameterType','Destroy','Score',' Destroy of ParameterType with with 71',NULL,'2007-03-20 11:54:10'),(551,NULL,72,'ParameterType','Destroy','Stats',' Destroy of ParameterType with with 72',NULL,'2007-03-20 11:54:14'),(552,NULL,73,'ParameterType','Destroy','Sex',' Destroy of ParameterType with with 73',NULL,'2007-03-20 11:54:17'),(553,NULL,74,'ParameterType','Destroy','Eliza Treatment',' Destroy of ParameterType with with 74',NULL,'2007-03-20 11:54:20'),(554,NULL,75,'ParameterType','Destroy','Properties',' Destroy of ParameterType with with 75',NULL,'2007-03-20 11:54:23'),(555,NULL,76,'ParameterType','Destroy','Descriptors',' Destroy of ParameterType with with 76',NULL,'2007-03-20 11:54:25'),(556,NULL,1,'ParameterType','Create','Label',' Create of ParameterType with with 1',NULL,'2007-03-20 14:13:12'),(557,NULL,2,'ParameterType','Create','Note',' Create of ParameterType with with 2',NULL,'2007-03-20 14:13:50'),(558,NULL,3,'ParameterType','Create','Activity',' Create of ParameterType with with 3',NULL,'2007-03-20 14:14:31'),(559,NULL,4,'ParameterType','Create','Statistic',' Create of ParameterType with with 4',NULL,'2007-03-20 14:14:55'),(560,NULL,5,'ParameterType','Create','Index',' Create of ParameterType with with 5',NULL,'2007-03-20 14:15:12'),(561,NULL,6,'ParameterType','Create','Counts',' Create of ParameterType with with 6',NULL,'2007-03-20 14:15:39'),(562,NULL,7,'ParameterType','Create','Measure',' Create of ParameterType with with 7',NULL,'2007-03-20 14:16:03'),(563,NULL,8,'ParameterType','Create','Fit Statistic',' Create of ParameterType with with 8',NULL,'2007-03-20 14:16:30'),(564,NULL,9,'ParameterType','Create','Concentration',' Create of ParameterType with with 9',NULL,'2007-03-20 14:16:57'),(565,NULL,10,'ParameterType','Create','Dose',' Create of ParameterType with with 10',NULL,'2007-03-20 14:18:14'),(566,NULL,11,'ParameterType','Create','Correction Factor',' Create of ParameterType with with 11',NULL,'2007-03-20 14:18:36'),(567,NULL,12,'ParameterType','Create','Sample Size',' Create of ParameterType with with 12',NULL,'2007-03-20 14:19:05'),(568,NULL,13,'ParameterType','Create','Link',' Create of ParameterType with with 13',NULL,'2007-03-20 14:59:55'),(569,NULL,14,'ParameterType','Create','Calculation',' Create of ParameterType with with 14',NULL,'2007-03-20 15:00:50'),(570,NULL,15,'ParameterType','Create','Sex',' Create of ParameterType with with 15',NULL,'2007-03-20 15:01:35'),(571,NULL,16,'ParameterType','Create','Route of Administration',' Create of ParameterType with with 16',NULL,'2007-03-20 15:02:13'),(572,NULL,17,'ParameterType','Create','Species',' Create of ParameterType with with 17',NULL,'2007-03-20 15:02:41'),(573,NULL,78,'DataElement','Create','KO Flag',' Create of ListElement with with 78',NULL,'2007-03-20 15:51:47'),(574,NULL,79,'DataElement','Create','QC Flag',' Create of ListElement with with 79',NULL,'2007-03-20 15:52:36'),(575,NULL,49,'DataConcept','Create','Flags',' Create of DataConcept with with 49',NULL,'2007-03-20 15:53:10'),(576,NULL,49,'DataConcept','Update','Flags',' Update of DataConcept with with 49',NULL,'2007-03-20 15:53:10'),(577,NULL,79,'DataElement','Destroy','QC Flag',' Destroy of ListElement with with 79',NULL,'2007-03-20 15:53:18'),(578,NULL,78,'DataElement','Destroy','KO Flag',' Destroy of ListElement with with 78',NULL,'2007-03-20 15:53:22'),(579,NULL,80,'DataElement','Create','QC',' Create of ListElement with with 80',NULL,'2007-03-20 15:54:30'),(580,NULL,81,'DataElement','Create','Progresssion',' Create of ListElement with with 81',NULL,'2007-03-20 15:55:17'),(581,NULL,82,'DataElement','Create','KO',' Create of ListElement with with 82',NULL,'2007-03-20 15:56:19'),(582,NULL,47,'DataConcept','Update','Species',' Update of DataConcept with with 47',NULL,'2007-03-20 15:57:04'),(583,NULL,63,'DataElement','Update','Small Species',' Update of ListElement with with 63',NULL,'2007-03-20 15:57:41'),(584,NULL,63,'DataElement','Update','Mammals',' Update of ListElement with with 63',NULL,'2007-03-20 15:57:59'),(585,NULL,17,'ParameterType','Update','Species',' Update of ParameterType with with 17',NULL,'2007-03-20 15:58:56'),(586,NULL,18,'ParameterType','Create','Flag',' Create of ParameterType with with 18',NULL,'2007-03-20 15:59:28'),(587,NULL,19,'ParameterType','Create','Treatment Role',' Create of ParameterType with with 19',NULL,'2007-03-20 16:00:18'),(588,NULL,20,'ParameterType','Create','Score',' Create of ParameterType with with 20',NULL,'2007-03-20 16:00:58'),(589,NULL,21,'ParameterType','Create','Date',' Create of ParameterType with with 21',NULL,'2007-03-20 16:01:14'),(590,NULL,22,'ParameterType','Create','Time',' Create of ParameterType with with 22',NULL,'2007-03-20 16:01:40'),(591,NULL,83,'DataElement','Create','significance',' Create of ListElement with with 83',NULL,'2007-03-20 16:13:38'),(592,NULL,23,'ParameterType','Create','Compound',' Create of ParameterType with with 23',NULL,'2007-03-20 16:23:42'),(593,NULL,84,'DataElement','Create','Boolean',' Create of ListElement with with 84',NULL,'2007-03-20 21:25:37');
/*!40000 ALTER TABLE `catalog_logs` ENABLE KEYS */;

--
-- Temporary table structure for view `compound_results`
--

DROP TABLE IF EXISTS `compound_results`;
/*!50001 DROP VIEW IF EXISTS `compound_results`*/;
/*!50001 CREATE TABLE `compound_results` (
  `id` int(11),
  `row_no` int(11),
  `column_no` int(11),
  `task_id` int(11),
  `parameter_context_id` int(11),
  `task_context_id` int(11),
  `data_element_id` int(11),
  `compound_parameter_id` int(11),
  `compound_id` int(11),
  `compound_name` varchar(255),
  `protocol_version_id` int(11),
  `label` varchar(255),
  `row_label` varchar(255),
  `parameter_id` int(11),
  `parameter_name` varchar(62),
  `data_value` double,
  `created_by` varchar(32),
  `created_at` datetime,
  `updated_by` varchar(32),
  `updated_at` datetime
) */;

--
-- Table structure for table `compounds`
--

DROP TABLE IF EXISTS `compounds`;
CREATE TABLE `compounds` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL default '',
  `description` text,
  `formula` varchar(50) default NULL,
  `mass` float default NULL,
  `smiles` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default 'sys',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default 'sys',
  `updated_at` datetime NOT NULL,
  `registration_date` datetime default NULL,
  `iupacname` varchar(255) default '',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `compounds`
--


/*!40000 ALTER TABLE `compounds` DISABLE KEYS */;
INSERT INTO `compounds` VALUES (1,'AB001','AB001','',NULL,'C(Cl)C(C)C(N)CCc1ccc(Cl)c(N)c1',4,'sys','2006-10-23 20:33:53','sys','2006-11-30 00:24:23',NULL,''),(2,'AB002','AB002',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:53','sys','2006-10-23 20:33:53',NULL,''),(3,'AB003','AB003',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:53','sys','2006-10-23 20:33:53',NULL,''),(4,'AB004','AB004',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:53','sys','2006-10-23 20:33:53',NULL,''),(5,'AB005','AB005',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:53','sys','2006-10-23 20:33:53',NULL,''),(6,'AB006','AB006',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:53','sys','2006-10-23 20:33:53',NULL,''),(7,'AB007','AB007',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:53','sys','2006-10-23 20:33:53',NULL,''),(8,'AB008','AB008',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:53','sys','2006-10-23 20:33:53',NULL,''),(9,'AB009','AB009',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:53','sys','2006-10-23 20:33:53',NULL,''),(10,'AB0010','AB0010',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:53','sys','2006-10-23 20:33:53',NULL,''),(11,'AB0011','AB0011',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:53','sys','2006-10-23 20:33:53',NULL,''),(12,'AB0012','AB0012',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:53','sys','2006-10-23 20:33:53',NULL,''),(13,'AB0013','AB0013',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:53','sys','2006-10-23 20:33:53',NULL,''),(14,'AB0014','AB0014',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:53','sys','2006-10-23 20:33:53',NULL,''),(15,'AB0015','AB0015',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:53','sys','2006-10-23 20:33:53',NULL,''),(16,'AB0016','AB0016',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:53','sys','2006-10-23 20:33:53',NULL,''),(17,'AB0017','AB0017',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:53','sys','2006-10-23 20:33:53',NULL,''),(18,'AB0018','AB0018',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:53','sys','2006-10-23 20:33:53',NULL,''),(19,'AB0019','AB0019',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:53','sys','2006-10-23 20:33:53',NULL,''),(20,'AB0020','AB0020',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:53','sys','2006-10-23 20:33:53',NULL,''),(21,'AB0021','AB0021',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(22,'AB0022','AB0022',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(23,'AB0023','AB0023',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(24,'AB0024','AB0024',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(25,'AB0025','AB0025',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(26,'AB0026','AB0026',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(27,'AB0027','AB0027',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(28,'AB0028','AB0028',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(29,'AB0029','AB0029',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(30,'AB0030','AB0030',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(31,'AB0031','AB0031',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(32,'AB0032','AB0032',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(33,'AB0033','AB0033',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(34,'AB0034','AB0034',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(35,'AB0035','AB0035',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(36,'AB0036','AB0036',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(37,'AB0037','AB0037',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(38,'AB0038','AB0038',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(39,'AB0039','AB0039',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(40,'AB0040','AB0040',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(41,'AB0041','AB0041',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(42,'AB0042','AB0042',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(43,'AB0043','AB0043',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(44,'AB0044','AB0044',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(45,'AB0045','AB0045',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(46,'AB0046','AB0046',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(47,'AB0047','AB0047',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(48,'AB0048','AB0048',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(49,'AB0049','AB0049',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(50,'AB0050','AB0050',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:54','sys','2006-10-23 20:33:54',NULL,''),(51,'AB0051','AB0051',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(52,'AB0052','AB0052',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(53,'AB0053','AB0053',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(54,'AB0054','AB0054',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(55,'AB0055','AB0055',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(56,'AB0056','AB0056',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(57,'AB0057','AB0057',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(58,'AB0058','AB0058',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(59,'AB0059','AB0059',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(60,'AB0060','AB0060',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(61,'AB0061','AB0061',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(62,'AB0062','AB0062',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(63,'AB0063','AB0063',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(64,'AB0064','AB0064',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(65,'AB0065','AB0065',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(66,'AB0066','AB0066',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(67,'AB0067','AB0067',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(68,'AB0068','AB0068',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(69,'AB0069','AB0069',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(70,'AB0070','AB0070',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(71,'AB0071','AB0071',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(72,'AB0072','AB0072',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(73,'AB0073','AB0073',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(74,'AB0074','AB0074',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(75,'AB0075','AB0075',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(76,'AB0076','AB0076',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(77,'AB0077','AB0077',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(78,'AB0078','AB0078',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(79,'AB0079','AB0079',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(80,'AB0080','AB0080',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(81,'AB0081','AB0081',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(82,'AB0082','AB0082',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(83,'AB0083','AB0083',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:55','sys','2006-10-23 20:33:55',NULL,''),(84,'AB0084','AB0084',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(85,'AB0085','AB0085',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(86,'AB0086','AB0086',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(87,'AB0087','AB0087',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(88,'AB0088','AB0088',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(89,'AB0089','AB0089',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(90,'AB0090','AB0090',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(91,'AB0091','AB0091',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(92,'AB0092','AB0092',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(93,'AB0093','AB0093',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(94,'AB0094','AB0094',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(95,'AB0095','AB0095',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(96,'AB0096','AB0096',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(97,'AB0097','AB0097',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(98,'AB0098','AB0098',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(99,'AB0099','AB0099',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(100,'AB00100','AB00100',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(101,'AB00101','AB00101',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(102,'AB00102','AB00102',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(103,'AB00103','AB00103',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(104,'AB00104','AB00104',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(105,'AB00105','AB00105',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(106,'AB00106','AB00106',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(107,'AB00107','AB00107',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(108,'AB00108','AB00108',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(109,'AB00109','AB00109',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(110,'AB00110','AB00110',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(111,'AB00111','AB00111',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(112,'AB00112','AB00112',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(113,'AB00113','AB00113',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(114,'AB00114','AB00114',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(115,'AB00115','AB00115',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(116,'AB00116','AB00116',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(117,'AB00117','AB00117',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(118,'AB00118','AB00118',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(119,'AB00119','AB00119',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:56','sys','2006-10-23 20:33:56',NULL,''),(120,'AB00120','AB00120',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(121,'AB00121','AB00121',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(122,'AB00122','AB00122',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(123,'AB00123','AB00123',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(124,'AB00124','AB00124',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(125,'AB00125','AB00125',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(126,'AB00126','AB00126',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(127,'AB00127','AB00127',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(128,'AB00128','AB00128',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(129,'AB00129','AB00129',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(130,'AB00130','AB00130',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(131,'AB00131','AB00131',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(132,'AB00132','AB00132',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(133,'AB00133','AB00133',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(134,'AB00134','AB00134',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(135,'AB00135','AB00135',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(136,'AB00136','AB00136',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(137,'AB00137','AB00137',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(138,'AB00138','AB00138',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(139,'AB00139','AB00139',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(140,'AB00140','AB00140',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(141,'AB00141','AB00141',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(142,'AB00142','AB00142',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(143,'AB00143','AB00143',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(144,'AB00144','AB00144',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(145,'AB00145','AB00145',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(146,'AB00146','AB00146',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(147,'AB00147','AB00147',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(148,'AB00148','AB00148',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(149,'AB00149','AB00149',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(150,'AB00150','AB00150',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(151,'AB00151','AB00151',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(152,'AB00152','AB00152',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(153,'AB00153','AB00153',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(154,'AB00154','AB00154',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(155,'AB00155','AB00155',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(156,'AB00156','AB00156',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:57','sys','2006-10-23 20:33:57',NULL,''),(157,'AB00157','AB00157',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(158,'AB00158','AB00158',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(159,'AB00159','AB00159',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(160,'AB00160','AB00160',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(161,'AB00161','AB00161',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(162,'AB00162','AB00162',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(163,'AB00163','AB00163',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(164,'AB00164','AB00164',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(165,'AB00165','AB00165',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(166,'AB00166','AB00166',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(167,'AB00167','AB00167',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(168,'AB00168','AB00168',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(169,'AB00169','AB00169',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(170,'AB00170','AB00170',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(171,'AB00171','AB00171',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(172,'AB00172','AB00172',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(173,'AB00173','AB00173',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(174,'AB00174','AB00174',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(175,'AB00175','AB00175',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(176,'AB00176','AB00176',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(177,'AB00177','AB00177',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(178,'AB00178','AB00178',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(179,'AB00179','AB00179',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(180,'AB00180','AB00180',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(181,'AB00181','AB00181',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(182,'AB00182','AB00182',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(183,'AB00183','AB00183',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(184,'AB00184','AB00184',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(185,'AB00185','AB00185',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(186,'AB00186','AB00186',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(187,'AB00187','AB00187',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(188,'AB00188','AB00188',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(189,'AB00189','AB00189',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(190,'AB00190','AB00190',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:58','sys','2006-10-23 20:33:58',NULL,''),(191,'AB00191','AB00191',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(192,'AB00192','AB00192',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(193,'AB00193','AB00193',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(194,'AB00194','AB00194',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(195,'AB00195','AB00195',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(196,'AB00196','AB00196',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(197,'AB00197','AB00197',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(198,'AB00198','AB00198',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(199,'AB00199','AB00199',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(200,'AB00200','AB00200',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(201,'AB00201','AB00201',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(202,'AB00202','AB00202',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(203,'AB00203','AB00203',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(204,'AB00204','AB00204',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(205,'AB00205','AB00205',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(206,'AB00206','AB00206',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(207,'AB00207','AB00207',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(208,'AB00208','AB00208',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(209,'AB00209','AB00209',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(210,'AB00210','AB00210',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(211,'AB00211','AB00211',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(212,'AB00212','AB00212',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(213,'AB00213','AB00213',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(214,'AB00214','AB00214',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(215,'AB00215','AB00215',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(216,'AB00216','AB00216',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(217,'AB00217','AB00217',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(218,'AB00218','AB00218',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(219,'AB00219','AB00219',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(220,'AB00220','AB00220',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(221,'AB00221','AB00221',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(222,'AB00222','AB00222',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(223,'AB00223','AB00223',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(224,'AB00224','AB00224',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(225,'AB00225','AB00225',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(226,'AB00226','AB00226',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:33:59',NULL,''),(227,'AB00227','AB00227',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:33:59','sys','2006-10-23 20:34:00',NULL,''),(228,'AB00228','AB00228',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(229,'AB00229','AB00229',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(230,'AB00230','AB00230',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(231,'AB00231','AB00231',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(232,'AB00232','AB00232',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(233,'AB00233','AB00233',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(234,'AB00234','AB00234',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(235,'AB00235','AB00235',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(236,'AB00236','AB00236',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(237,'AB00237','AB00237',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(238,'AB00238','AB00238',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(239,'AB00239','AB00239',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(240,'AB00240','AB00240',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(241,'AB00241','AB00241',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(242,'AB00242','AB00242',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(243,'AB00243','AB00243',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(244,'AB00244','AB00244',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(245,'AB00245','AB00245',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(246,'AB00246','AB00246',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(247,'AB00247','AB00247',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(248,'AB00248','AB00248',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(249,'AB00249','AB00249',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(250,'AB00250','AB00250',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(251,'AB00251','AB00251',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(252,'AB00252','AB00252',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(253,'AB00253','AB00253',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(254,'AB00254','AB00254',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(255,'AB00255','AB00255',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:00','sys','2006-10-23 20:34:00',NULL,''),(256,'AB00256','AB00256',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(257,'AB00257','AB00257',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(258,'AB00258','AB00258',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(259,'AB00259','AB00259',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(260,'AB00260','AB00260',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(261,'AB00261','AB00261',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(262,'AB00262','AB00262',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(263,'AB00263','AB00263',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(264,'AB00264','AB00264',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(265,'AB00265','AB00265',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(266,'AB00266','AB00266',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(267,'AB00267','AB00267',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(268,'AB00268','AB00268',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(269,'AB00269','AB00269',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(270,'AB00270','AB00270',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(271,'AB00271','AB00271',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(272,'AB00272','AB00272',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(273,'AB00273','AB00273',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(274,'AB00274','AB00274',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(275,'AB00275','AB00275',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(276,'AB00276','AB00276',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(277,'AB00277','AB00277',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(278,'AB00278','AB00278',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(279,'AB00279','AB00279',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(280,'AB00280','AB00280',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(281,'AB00281','AB00281',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(282,'AB00282','AB00282',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(283,'AB00283','AB00283',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(284,'AB00284','AB00284',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:01','sys','2006-10-23 20:34:01',NULL,''),(285,'AB00285','AB00285',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(286,'AB00286','AB00286',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(287,'AB00287','AB00287',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(288,'AB00288','AB00288',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(289,'AB00289','AB00289',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(290,'AB00290','AB00290',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(291,'AB00291','AB00291',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(292,'AB00292','AB00292',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(293,'AB00293','AB00293',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(294,'AB00294','AB00294',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(295,'AB00295','AB00295',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(296,'AB00296','AB00296',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(297,'AB00297','AB00297',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(298,'AB00298','AB00298',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(299,'AB00299','AB00299',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(300,'AB00300','AB00300',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(301,'AB00301','AB00301',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(302,'AB00302','AB00302',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(303,'AB00303','AB00303',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(304,'AB00304','AB00304',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(305,'AB00305','AB00305',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(306,'AB00306','AB00306',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(307,'AB00307','AB00307',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(308,'AB00308','AB00308',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(309,'AB00309','AB00309',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(310,'AB00310','AB00310',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(311,'AB00311','AB00311',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(312,'AB00312','AB00312',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(313,'AB00313','AB00313',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(314,'AB00314','AB00314',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(315,'AB00315','AB00315',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:02','sys','2006-10-23 20:34:02',NULL,''),(316,'AB00316','AB00316',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(317,'AB00317','AB00317',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(318,'AB00318','AB00318',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(319,'AB00319','AB00319',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(320,'AB00320','AB00320',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(321,'AB00321','AB00321',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(322,'AB00322','AB00322',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(323,'AB00323','AB00323',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(324,'AB00324','AB00324',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(325,'AB00325','AB00325',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(326,'AB00326','AB00326',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(327,'AB00327','AB00327',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(328,'AB00328','AB00328',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(329,'AB00329','AB00329',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(330,'AB00330','AB00330',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(331,'AB00331','AB00331',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(332,'AB00332','AB00332',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(333,'AB00333','AB00333',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(334,'AB00334','AB00334',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(335,'AB00335','AB00335',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(336,'AB00336','AB00336',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(337,'AB00337','AB00337',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(338,'AB00338','AB00338',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(339,'AB00339','AB00339',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(340,'AB00340','AB00340',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(341,'AB00341','AB00341',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(342,'AB00342','AB00342',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(343,'AB00343','AB00343',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(344,'AB00344','AB00344',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:03','sys','2006-10-23 20:34:03',NULL,''),(345,'AB00345','AB00345',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(346,'AB00346','AB00346',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(347,'AB00347','AB00347',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(348,'AB00348','AB00348',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(349,'AB00349','AB00349',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(350,'AB00350','AB00350',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(351,'AB00351','AB00351',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(352,'AB00352','AB00352',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(353,'AB00353','AB00353',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(354,'AB00354','AB00354',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(355,'AB00355','AB00355',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(356,'AB00356','AB00356',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(357,'AB00357','AB00357',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(358,'AB00358','AB00358',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(359,'AB00359','AB00359',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(360,'AB00360','AB00360',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(361,'AB00361','AB00361',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(362,'AB00362','AB00362',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(363,'AB00363','AB00363',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(364,'AB00364','AB00364',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(365,'AB00365','AB00365',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(366,'AB00366','AB00366',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(367,'AB00367','AB00367',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(368,'AB00368','AB00368',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(369,'AB00369','AB00369',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(370,'AB00370','AB00370',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(371,'AB00371','AB00371',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(372,'AB00372','AB00372',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(373,'AB00373','AB00373',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(374,'AB00374','AB00374',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(375,'AB00375','AB00375',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(376,'AB00376','AB00376',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(377,'AB00377','AB00377',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:04','sys','2006-10-23 20:34:04',NULL,''),(378,'AB00378','AB00378',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(379,'AB00379','AB00379',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(380,'AB00380','AB00380',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(381,'AB00381','AB00381',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(382,'AB00382','AB00382',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(383,'AB00383','AB00383',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(384,'AB00384','AB00384',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(385,'AB00385','AB00385',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(386,'AB00386','AB00386',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(387,'AB00387','AB00387',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(388,'AB00388','AB00388',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(389,'AB00389','AB00389',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(390,'AB00390','AB00390',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(391,'AB00391','AB00391',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(392,'AB00392','AB00392',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(393,'AB00393','AB00393',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(394,'AB00394','AB00394',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(395,'AB00395','AB00395',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(396,'AB00396','AB00396',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(397,'AB00397','AB00397',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(398,'AB00398','AB00398',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(399,'AB00399','AB00399',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(400,'AB00400','AB00400',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(401,'AB00401','AB00401',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(402,'AB00402','AB00402',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(403,'AB00403','AB00403',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(404,'AB00404','AB00404',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(405,'AB00405','AB00405',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(406,'AB00406','AB00406',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(407,'AB00407','AB00407',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(408,'AB00408','AB00408',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(409,'AB00409','AB00409',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(410,'AB00410','AB00410',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(411,'AB00411','AB00411',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(412,'AB00412','AB00412',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:05','sys','2006-10-23 20:34:05',NULL,''),(413,'AB00413','AB00413',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(414,'AB00414','AB00414',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(415,'AB00415','AB00415',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(416,'AB00416','AB00416',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(417,'AB00417','AB00417',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(418,'AB00418','AB00418',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(419,'AB00419','AB00419',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(420,'AB00420','AB00420',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(421,'AB00421','AB00421',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(422,'AB00422','AB00422',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(423,'AB00423','AB00423',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(424,'AB00424','AB00424',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(425,'AB00425','AB00425',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(426,'AB00426','AB00426',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(427,'AB00427','AB00427',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(428,'AB00428','AB00428',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(429,'AB00429','AB00429',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(430,'AB00430','AB00430',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(431,'AB00431','AB00431',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(432,'AB00432','AB00432',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(433,'AB00433','AB00433',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(434,'AB00434','AB00434',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(435,'AB00435','AB00435',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(436,'AB00436','AB00436',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(437,'AB00437','AB00437',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(438,'AB00438','AB00438',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(439,'AB00439','AB00439',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(440,'AB00440','AB00440',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(441,'AB00441','AB00441',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(442,'AB00442','AB00442',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(443,'AB00443','AB00443',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(444,'AB00444','AB00444',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(445,'AB00445','AB00445',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(446,'AB00446','AB00446',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(447,'AB00447','AB00447',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(448,'AB00448','AB00448',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:06','sys','2006-10-23 20:34:06',NULL,''),(449,'AB00449','AB00449',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(450,'AB00450','AB00450',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(451,'AB00451','AB00451',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(452,'AB00452','AB00452',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(453,'AB00453','AB00453',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(454,'AB00454','AB00454',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(455,'AB00455','AB00455',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(456,'AB00456','AB00456',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(457,'AB00457','AB00457',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(458,'AB00458','AB00458',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(459,'AB00459','AB00459',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(460,'AB00460','AB00460',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(461,'AB00461','AB00461',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(462,'AB00462','AB00462',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(463,'AB00463','AB00463',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(464,'AB00464','AB00464',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(465,'AB00465','AB00465',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(466,'AB00466','AB00466',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(467,'AB00467','AB00467',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(468,'AB00468','AB00468',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(469,'AB00469','AB00469',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(470,'AB00470','AB00470',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(471,'AB00471','AB00471',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(472,'AB00472','AB00472',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(473,'AB00473','AB00473',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(474,'AB00474','AB00474',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(475,'AB00475','AB00475',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(476,'AB00476','AB00476',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(477,'AB00477','AB00477',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(478,'AB00478','AB00478',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(479,'AB00479','AB00479',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(480,'AB00480','AB00480',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(481,'AB00481','AB00481',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(482,'AB00482','AB00482',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:07','sys','2006-10-23 20:34:07',NULL,''),(483,'AB00483','AB00483',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(484,'AB00484','AB00484',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(485,'AB00485','AB00485',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(486,'AB00486','AB00486',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(487,'AB00487','AB00487',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(488,'AB00488','AB00488',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(489,'AB00489','AB00489',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(490,'AB00490','AB00490',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(491,'AB00491','AB00491',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(492,'AB00492','AB00492',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(493,'AB00493','AB00493',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(494,'AB00494','AB00494',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(495,'AB00495','AB00495',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(496,'AB00496','AB00496',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(497,'AB00497','AB00497',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(498,'AB00498','AB00498',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(499,'AB00499','AB00499',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(500,'AB00500','AB00500',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(501,'AB00501','AB00501',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(502,'AB00502','AB00502',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(503,'AB00503','AB00503',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(504,'AB00504','AB00504',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(505,'AB00505','AB00505',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(506,'AB00506','AB00506',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(507,'AB00507','AB00507',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(508,'AB00508','AB00508',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(509,'AB00509','AB00509',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(510,'AB00510','AB00510',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(511,'AB00511','AB00511',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(512,'AB00512','AB00512',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(513,'AB00513','AB00513',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(514,'AB00514','AB00514',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(515,'AB00515','AB00515',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(516,'AB00516','AB00516',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(517,'AB00517','AB00517',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(518,'AB00518','AB00518',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(519,'AB00519','AB00519',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(520,'AB00520','AB00520',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:08','sys','2006-10-23 20:34:08',NULL,''),(521,'AB00521','AB00521',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(522,'AB00522','AB00522',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(523,'AB00523','AB00523',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(524,'AB00524','AB00524',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(525,'AB00525','AB00525',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(526,'AB00526','AB00526',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(527,'AB00527','AB00527',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(528,'AB00528','AB00528',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(529,'AB00529','AB00529',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(530,'AB00530','AB00530',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(531,'AB00531','AB00531',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(532,'AB00532','AB00532',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(533,'AB00533','AB00533',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(534,'AB00534','AB00534',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(535,'AB00535','AB00535',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(536,'AB00536','AB00536',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(537,'AB00537','AB00537',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(538,'AB00538','AB00538',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(539,'AB00539','AB00539',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(540,'AB00540','AB00540',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(541,'AB00541','AB00541',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(542,'AB00542','AB00542',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(543,'AB00543','AB00543',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(544,'AB00544','AB00544',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(545,'AB00545','AB00545',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(546,'AB00546','AB00546',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(547,'AB00547','AB00547',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(548,'AB00548','AB00548',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(549,'AB00549','AB00549',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(550,'AB00550','AB00550',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(551,'AB00551','AB00551',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(552,'AB00552','AB00552',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(553,'AB00553','AB00553',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(554,'AB00554','AB00554',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(555,'AB00555','AB00555',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:09','sys','2006-10-23 20:34:09',NULL,''),(556,'AB00556','AB00556',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(557,'AB00557','AB00557',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(558,'AB00558','AB00558',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(559,'AB00559','AB00559',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(560,'AB00560','AB00560',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(561,'AB00561','AB00561',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(562,'AB00562','AB00562',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(563,'AB00563','AB00563',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(564,'AB00564','AB00564',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(565,'AB00565','AB00565',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(566,'AB00566','AB00566',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(567,'AB00567','AB00567',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(568,'AB00568','AB00568',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(569,'AB00569','AB00569',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(570,'AB00570','AB00570',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(571,'AB00571','AB00571',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(572,'AB00572','AB00572',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(573,'AB00573','AB00573',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(574,'AB00574','AB00574',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(575,'AB00575','AB00575',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(576,'AB00576','AB00576',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(577,'AB00577','AB00577',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(578,'AB00578','AB00578',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(579,'AB00579','AB00579',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(580,'AB00580','AB00580',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(581,'AB00581','AB00581',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(582,'AB00582','AB00582',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(583,'AB00583','AB00583',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(584,'AB00584','AB00584',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(585,'AB00585','AB00585',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(586,'AB00586','AB00586',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(587,'AB00587','AB00587',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(588,'AB00588','AB00588',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(589,'AB00589','AB00589',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:10','sys','2006-10-23 20:34:10',NULL,''),(590,'AB00590','AB00590',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(591,'AB00591','AB00591',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(592,'AB00592','AB00592',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(593,'AB00593','AB00593',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(594,'AB00594','AB00594',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(595,'AB00595','AB00595',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(596,'AB00596','AB00596',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(597,'AB00597','AB00597',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(598,'AB00598','AB00598',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(599,'AB00599','AB00599',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(600,'AB00600','AB00600',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(601,'AB00601','AB00601',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(602,'AB00602','AB00602',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(603,'AB00603','AB00603',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(604,'AB00604','AB00604',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(605,'AB00605','AB00605',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(606,'AB00606','AB00606',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(607,'AB00607','AB00607',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(608,'AB00608','AB00608',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(609,'AB00609','AB00609',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(610,'AB00610','AB00610',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(611,'AB00611','AB00611',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(612,'AB00612','AB00612',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(613,'AB00613','AB00613',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(614,'AB00614','AB00614',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(615,'AB00615','AB00615',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(616,'AB00616','AB00616',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(617,'AB00617','AB00617',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(618,'AB00618','AB00618',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(619,'AB00619','AB00619',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(620,'AB00620','AB00620',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(621,'AB00621','AB00621',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(622,'AB00622','AB00622',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(623,'AB00623','AB00623',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(624,'AB00624','AB00624',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(625,'AB00625','AB00625',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(626,'AB00626','AB00626',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:11','sys','2006-10-23 20:34:11',NULL,''),(627,'AB00627','AB00627',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(628,'AB00628','AB00628',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(629,'AB00629','AB00629',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(630,'AB00630','AB00630',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(631,'AB00631','AB00631',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(632,'AB00632','AB00632',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(633,'AB00633','AB00633',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(634,'AB00634','AB00634',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(635,'AB00635','AB00635',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(636,'AB00636','AB00636',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(637,'AB00637','AB00637',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(638,'AB00638','AB00638',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(639,'AB00639','AB00639',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(640,'AB00640','AB00640',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(641,'AB00641','AB00641',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(642,'AB00642','AB00642',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(643,'AB00643','AB00643',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(644,'AB00644','AB00644',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(645,'AB00645','AB00645',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(646,'AB00646','AB00646',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(647,'AB00647','AB00647',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(648,'AB00648','AB00648',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(649,'AB00649','AB00649',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(650,'AB00650','AB00650',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(651,'AB00651','AB00651',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(652,'AB00652','AB00652',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(653,'AB00653','AB00653',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(654,'AB00654','AB00654',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(655,'AB00655','AB00655',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(656,'AB00656','AB00656',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(657,'AB00657','AB00657',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(658,'AB00658','AB00658',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(659,'AB00659','AB00659',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(660,'AB00660','AB00660',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(661,'AB00661','AB00661',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:12','sys','2006-10-23 20:34:12',NULL,''),(662,'AB00662','AB00662',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(663,'AB00663','AB00663',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(664,'AB00664','AB00664',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(665,'AB00665','AB00665',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(666,'AB00666','AB00666',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(667,'AB00667','AB00667',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(668,'AB00668','AB00668',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(669,'AB00669','AB00669',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(670,'AB00670','AB00670',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(671,'AB00671','AB00671',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(672,'AB00672','AB00672',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(673,'AB00673','AB00673',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(674,'AB00674','AB00674',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(675,'AB00675','AB00675',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(676,'AB00676','AB00676',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(677,'AB00677','AB00677',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(678,'AB00678','AB00678',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(679,'AB00679','AB00679',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(680,'AB00680','AB00680',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(681,'AB00681','AB00681',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(682,'AB00682','AB00682',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(683,'AB00683','AB00683',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(684,'AB00684','AB00684',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(685,'AB00685','AB00685',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(686,'AB00686','AB00686',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(687,'AB00687','AB00687',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(688,'AB00688','AB00688',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(689,'AB00689','AB00689',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(690,'AB00690','AB00690',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:13','sys','2006-10-23 20:34:13',NULL,''),(691,'AB00691','AB00691',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(692,'AB00692','AB00692',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(693,'AB00693','AB00693',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(694,'AB00694','AB00694',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(695,'AB00695','AB00695',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(696,'AB00696','AB00696',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(697,'AB00697','AB00697',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(698,'AB00698','AB00698',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(699,'AB00699','AB00699',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(700,'AB00700','AB00700',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(701,'AB00701','AB00701',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(702,'AB00702','AB00702',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(703,'AB00703','AB00703',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(704,'AB00704','AB00704',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(705,'AB00705','AB00705',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(706,'AB00706','AB00706',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(707,'AB00707','AB00707',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(708,'AB00708','AB00708',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(709,'AB00709','AB00709',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(710,'AB00710','AB00710',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(711,'AB00711','AB00711',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(712,'AB00712','AB00712',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(713,'AB00713','AB00713',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(714,'AB00714','AB00714',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(715,'AB00715','AB00715',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(716,'AB00716','AB00716',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(717,'AB00717','AB00717',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:14','sys','2006-10-23 20:34:14',NULL,''),(718,'AB00718','AB00718',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(719,'AB00719','AB00719',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(720,'AB00720','AB00720',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(721,'AB00721','AB00721',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(722,'AB00722','AB00722',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(723,'AB00723','AB00723',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(724,'AB00724','AB00724',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(725,'AB00725','AB00725',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(726,'AB00726','AB00726',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(727,'AB00727','AB00727',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(728,'AB00728','AB00728',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(729,'AB00729','AB00729',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(730,'AB00730','AB00730',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(731,'AB00731','AB00731',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(732,'AB00732','AB00732',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(733,'AB00733','AB00733',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(734,'AB00734','AB00734',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(735,'AB00735','AB00735',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(736,'AB00736','AB00736',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(737,'AB00737','AB00737',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(738,'AB00738','AB00738',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(739,'AB00739','AB00739',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(740,'AB00740','AB00740',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(741,'AB00741','AB00741',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(742,'AB00742','AB00742',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(743,'AB00743','AB00743',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(744,'AB00744','AB00744',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(745,'AB00745','AB00745',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(746,'AB00746','AB00746',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:15','sys','2006-10-23 20:34:15',NULL,''),(747,'AB00747','AB00747',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(748,'AB00748','AB00748',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(749,'AB00749','AB00749',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(750,'AB00750','AB00750',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(751,'AB00751','AB00751',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(752,'AB00752','AB00752',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(753,'AB00753','AB00753',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(754,'AB00754','AB00754',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(755,'AB00755','AB00755',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(756,'AB00756','AB00756',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(757,'AB00757','AB00757',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(758,'AB00758','AB00758',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(759,'AB00759','AB00759',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(760,'AB00760','AB00760',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(761,'AB00761','AB00761',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(762,'AB00762','AB00762',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(763,'AB00763','AB00763',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(764,'AB00764','AB00764',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(765,'AB00765','AB00765',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(766,'AB00766','AB00766',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(767,'AB00767','AB00767',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(768,'AB00768','AB00768',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(769,'AB00769','AB00769',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(770,'AB00770','AB00770',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(771,'AB00771','AB00771',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(772,'AB00772','AB00772',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(773,'AB00773','AB00773',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(774,'AB00774','AB00774',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:16','sys','2006-10-23 20:34:16',NULL,''),(775,'AB00775','AB00775',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(776,'AB00776','AB00776',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(777,'AB00777','AB00777',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(778,'AB00778','AB00778',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(779,'AB00779','AB00779',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(780,'AB00780','AB00780',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(781,'AB00781','AB00781',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(782,'AB00782','AB00782',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(783,'AB00783','AB00783',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(784,'AB00784','AB00784',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(785,'AB00785','AB00785',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(786,'AB00786','AB00786',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(787,'AB00787','AB00787',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(788,'AB00788','AB00788',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(789,'AB00789','AB00789',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(790,'AB00790','AB00790',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(791,'AB00791','AB00791',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(792,'AB00792','AB00792',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(793,'AB00793','AB00793',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(794,'AB00794','AB00794',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(795,'AB00795','AB00795',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(796,'AB00796','AB00796',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(797,'AB00797','AB00797',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(798,'AB00798','AB00798',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(799,'AB00799','AB00799',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(800,'AB00800','AB00800',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(801,'AB00801','AB00801',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(802,'AB00802','AB00802',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(803,'AB00803','AB00803',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(804,'AB00804','AB00804',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:17','sys','2006-10-23 20:34:17',NULL,''),(805,'AB00805','AB00805',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(806,'AB00806','AB00806',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(807,'AB00807','AB00807',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(808,'AB00808','AB00808',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(809,'AB00809','AB00809',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(810,'AB00810','AB00810',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(811,'AB00811','AB00811',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(812,'AB00812','AB00812',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(813,'AB00813','AB00813',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(814,'AB00814','AB00814',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(815,'AB00815','AB00815',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(816,'AB00816','AB00816',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(817,'AB00817','AB00817',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(818,'AB00818','AB00818',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(819,'AB00819','AB00819',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(820,'AB00820','AB00820',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(821,'AB00821','AB00821',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(822,'AB00822','AB00822',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(823,'AB00823','AB00823',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(824,'AB00824','AB00824',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(825,'AB00825','AB00825',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(826,'AB00826','AB00826',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(827,'AB00827','AB00827',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(828,'AB00828','AB00828',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(829,'AB00829','AB00829',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(830,'AB00830','AB00830',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(831,'AB00831','AB00831',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(832,'AB00832','AB00832',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:18','sys','2006-10-23 20:34:18',NULL,''),(833,'AB00833','AB00833',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(834,'AB00834','AB00834',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(835,'AB00835','AB00835',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(836,'AB00836','AB00836',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(837,'AB00837','AB00837',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(838,'AB00838','AB00838',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(839,'AB00839','AB00839',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(840,'AB00840','AB00840',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(841,'AB00841','AB00841',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(842,'AB00842','AB00842',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(843,'AB00843','AB00843',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(844,'AB00844','AB00844',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(845,'AB00845','AB00845',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(846,'AB00846','AB00846',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(847,'AB00847','AB00847',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(848,'AB00848','AB00848',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(849,'AB00849','AB00849',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(850,'AB00850','AB00850',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(851,'AB00851','AB00851',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(852,'AB00852','AB00852',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(853,'AB00853','AB00853',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(854,'AB00854','AB00854',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(855,'AB00855','AB00855',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(856,'AB00856','AB00856',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(857,'AB00857','AB00857',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(858,'AB00858','AB00858',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(859,'AB00859','AB00859',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(860,'AB00860','AB00860',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(861,'AB00861','AB00861',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(862,'AB00862','AB00862',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:19','sys','2006-10-23 20:34:19',NULL,''),(863,'AB00863','AB00863',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(864,'AB00864','AB00864',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(865,'AB00865','AB00865',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(866,'AB00866','AB00866',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(867,'AB00867','AB00867',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(868,'AB00868','AB00868',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(869,'AB00869','AB00869',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(870,'AB00870','AB00870',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(871,'AB00871','AB00871',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(872,'AB00872','AB00872',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(873,'AB00873','AB00873',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(874,'AB00874','AB00874',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(875,'AB00875','AB00875',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(876,'AB00876','AB00876',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(877,'AB00877','AB00877',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(878,'AB00878','AB00878',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(879,'AB00879','AB00879',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(880,'AB00880','AB00880',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(881,'AB00881','AB00881',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(882,'AB00882','AB00882',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(883,'AB00883','AB00883',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(884,'AB00884','AB00884',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(885,'AB00885','AB00885',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(886,'AB00886','AB00886',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(887,'AB00887','AB00887',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(888,'AB00888','AB00888',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(889,'AB00889','AB00889',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(890,'AB00890','AB00890',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:20','sys','2006-10-23 20:34:20',NULL,''),(891,'AB00891','AB00891',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(892,'AB00892','AB00892',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(893,'AB00893','AB00893',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(894,'AB00894','AB00894',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(895,'AB00895','AB00895',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(896,'AB00896','AB00896',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(897,'AB00897','AB00897',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(898,'AB00898','AB00898',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(899,'AB00899','AB00899',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(900,'AB00900','AB00900',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(901,'AB00901','AB00901',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(902,'AB00902','AB00902',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(903,'AB00903','AB00903',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(904,'AB00904','AB00904',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(905,'AB00905','AB00905',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(906,'AB00906','AB00906',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(907,'AB00907','AB00907',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(908,'AB00908','AB00908',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(909,'AB00909','AB00909',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(910,'AB00910','AB00910',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(911,'AB00911','AB00911',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(912,'AB00912','AB00912',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(913,'AB00913','AB00913',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(914,'AB00914','AB00914',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(915,'AB00915','AB00915',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(916,'AB00916','AB00916',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(917,'AB00917','AB00917',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(918,'AB00918','AB00918',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(919,'AB00919','AB00919',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(920,'AB00920','AB00920',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:21','sys','2006-10-23 20:34:21',NULL,''),(921,'AB00921','AB00921',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(922,'AB00922','AB00922',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(923,'AB00923','AB00923',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(924,'AB00924','AB00924',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(925,'AB00925','AB00925',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(926,'AB00926','AB00926',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(927,'AB00927','AB00927',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(928,'AB00928','AB00928',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(929,'AB00929','AB00929',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(930,'AB00930','AB00930',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(931,'AB00931','AB00931',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(932,'AB00932','AB00932',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(933,'AB00933','AB00933',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(934,'AB00934','AB00934',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(935,'AB00935','AB00935',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(936,'AB00936','AB00936',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(937,'AB00937','AB00937',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(938,'AB00938','AB00938',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(939,'AB00939','AB00939',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(940,'AB00940','AB00940',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(941,'AB00941','AB00941',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(942,'AB00942','AB00942',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(943,'AB00943','AB00943',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(944,'AB00944','AB00944',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(945,'AB00945','AB00945',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(946,'AB00946','AB00946',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(947,'AB00947','AB00947',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(948,'AB00948','AB00948',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(949,'AB00949','AB00949',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(950,'AB00950','AB00950',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:22','sys','2006-10-23 20:34:22',NULL,''),(951,'AB00951','AB00951',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(952,'AB00952','AB00952',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(953,'AB00953','AB00953',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(954,'AB00954','AB00954',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(955,'AB00955','AB00955',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(956,'AB00956','AB00956',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(957,'AB00957','AB00957',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(958,'AB00958','AB00958',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(959,'AB00959','AB00959',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(960,'AB00960','AB00960',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(961,'AB00961','AB00961',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(962,'AB00962','AB00962',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(963,'AB00963','AB00963',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(964,'AB00964','AB00964',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(965,'AB00965','AB00965',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(966,'AB00966','AB00966',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(967,'AB00967','AB00967',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(968,'AB00968','AB00968',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(969,'AB00969','AB00969',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(970,'AB00970','AB00970',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(971,'AB00971','AB00971',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(972,'AB00972','AB00972',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(973,'AB00973','AB00973',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(974,'AB00974','AB00974',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(975,'AB00975','AB00975',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(976,'AB00976','AB00976',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(977,'AB00977','AB00977',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(978,'AB00978','AB00978',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(979,'AB00979','AB00979',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(980,'AB00980','AB00980',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(981,'AB00981','AB00981',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(982,'AB00982','AB00982',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(983,'AB00983','AB00983',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(984,'AB00984','AB00984',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(985,'AB00985','AB00985',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(986,'AB00986','AB00986',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:23','sys','2006-10-23 20:34:23',NULL,''),(987,'AB00987','AB00987',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:24','sys','2006-10-23 20:34:24',NULL,''),(988,'AB00988','AB00988',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:24','sys','2006-10-23 20:34:24',NULL,''),(989,'AB00989','AB00989',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:24','sys','2006-10-23 20:34:24',NULL,''),(990,'AB00990','AB00990',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:24','sys','2006-10-23 20:34:24',NULL,''),(991,'AB00991','AB00991',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:24','sys','2006-10-23 20:34:24',NULL,''),(992,'AB00992','AB00992',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:24','sys','2006-10-23 20:34:24',NULL,''),(993,'AB00993','AB00993',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:24','sys','2006-10-23 20:34:24',NULL,''),(994,'AB00994','AB00994',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:24','sys','2006-10-23 20:34:24',NULL,''),(995,'AB00995','AB00995',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:24','sys','2006-10-23 20:34:24',NULL,''),(996,'AB00996','AB00996',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:24','sys','2006-10-23 20:34:24',NULL,''),(997,'AB00997','AB00997',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:24','sys','2006-10-23 20:34:24',NULL,''),(998,'AB00998','AB00998',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:24','sys','2006-10-23 20:34:24',NULL,''),(999,'AB00999','AB00999',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:24','sys','2006-10-23 20:34:24',NULL,''),(1000,'AB001000','AB001000',NULL,NULL,'c1cc(N)c(Cl)cc1',0,'sys','2006-10-23 20:34:24','sys','2006-10-23 20:34:24',NULL,''),(1001,'BLANK','I know its a well literal not a compound!','',NULL,'',0,'sys','2007-02-06 09:16:29','sys','2007-02-06 09:16:29','2007-02-06 00:00:00',''),(1002,'TOTB','A new well literal, sorry','',NULL,'',0,'sys','2007-02-06 09:17:03','sys','2007-02-06 09:17:03','2007-02-06 00:00:00',''),(1003,'5pcHPbC','used as negative control in Res_Exposure assay','',NULL,'',1,'sys','2007-03-21 15:20:47','sys','2007-03-21 15:26:02','2007-03-21 00:00:00',''),(1004,'02707','pos control?','',NULL,'',0,'sys','2007-03-21 15:21:40','sys','2007-03-21 15:21:40','2007-03-21 00:00:00',''),(1005,'00749','Vehicle','',NULL,'',0,'sys','2007-03-21 15:22:35','sys','2007-03-21 15:22:35','2007-03-21 00:00:00',''),(1006,'saline','Saline','',NULL,'',0,'sys','2007-03-21 15:26:51','sys','2007-03-21 15:26:51','2007-03-21 00:00:00','');
/*!40000 ALTER TABLE `compounds` ENABLE KEYS */;

--
-- Table structure for table `container_items`
--

DROP TABLE IF EXISTS `container_items`;
CREATE TABLE `container_items` (
  `id` int(11) NOT NULL auto_increment,
  `container_group_id` int(11) NOT NULL,
  `subject_type` varchar(255) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `slot_no` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `container_items`
--


/*!40000 ALTER TABLE `container_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `container_items` ENABLE KEYS */;

--
-- Table structure for table `containers`
--

DROP TABLE IF EXISTS `containers`;
CREATE TABLE `containers` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `plate_format_id` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `containers`
--


/*!40000 ALTER TABLE `containers` DISABLE KEYS */;
/*!40000 ALTER TABLE `containers` ENABLE KEYS */;

--
-- Table structure for table `content_pages`
--

DROP TABLE IF EXISTS `content_pages`;
CREATE TABLE `content_pages` (
  `id` int(11) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `name` varchar(255) NOT NULL,
  `markup_style_id` int(11) default NULL,
  `content` text,
  `permission_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `content_cache` text,
  PRIMARY KEY  (`id`),
  KEY `fk_content_page_permission_id` (`permission_id`),
  KEY `fk_content_page_markup_style_id` (`markup_style_id`),
  CONSTRAINT `fk_content_page_markup_style_id` FOREIGN KEY (`markup_style_id`) REFERENCES `markup_styles` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_content_page_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `content_pages`
--


/*!40000 ALTER TABLE `content_pages` DISABLE KEYS */;
INSERT INTO `content_pages` VALUES (1,'Home Page','home',1,'<div style=\"background-color:white;\">\r\n\r\nh1. Getting Started\r\n\r\nh2. Start Here\r\n\r\nh6. !/images/pointing.png! \r\n\r\nThe best place to start is the *Finder* on the right.  Type the first few letters of thing you are looking in the Search Box and the finder will present you with a list of categorized hits.  Each hit is a __short-cut__ to a record.  You should be less then __3-clicks__ away from your data.\r\n\r\nh2. Overview\r\n\r\nBioRails is a study management system for preclinical researchers.  It is designed to help the biologist and pharmacologist organize Studies and execute experiments and tasks within them as well as providing a platform for annotation and reporting. \r\n\r\n<div style=\"float:right;\">\r\n\r\nh2. Layout\r\n\r\n||\\3.   Main Menus   ||\r\n||/2.  Finder  ||  Data Lenses  ||/2.  Context  ||\r\n||  Main Content  ||\r\n||\\3.  Footer   ||\r\n\r\n</div>\r\n\r\nh2. Main Menus\r\n\r\nh3. \"Home\":/menu/home\r\n\r\nSystem Overview.\r\n\r\nh3. My Home\r\n\r\nDefault page for scientists.  View reports, browse records tasks and annotations associated with the logged on user.\r\n\r\nh3. \"Study\":/menu/Organization\r\n\r\nOrganise the study: define access rights for scientists, set terminology and map to corporate standards, define assays, review progress.  \r\n\r\nh3. \"Experiment\":/menu/Execution\r\n\r\nRun experiments. Experiments are broken down into their composite tasks, some of which sporn data entry sheets, others, external process, review progress, add new tasks and amend old ones.\r\n\r\nh3. \"Catalogue\":/menu/Catalogue (Administrators Only)\r\n\r\nThe glue for all the different systems into which BioRails is integrated.  These systems may be defined within BioRails or mapped to external databases etc.\r\n<div style=\"float:right;\">\r\n\r\n!/images/icon.png!\r\n\r\n</div>\r\n\r\nh3. \"Inventory\":/menu/Inventory\r\n\r\n__Stuff__ used in studies.  Inventory is defined during the installation and tends to be used for compound, plates and samples although can equally extend to mixtures, formulations, animals in cages etc.\r\n\r\nh3. \"Setup\":/menu/setup (Administrators only) \r\n\r\nSystem configuration such as users, new controllers, menu editing, system settings.\r\n</div>',3,'2006-06-11 14:31:56','2007-01-30 12:48:34',NULL),(2,'Session Expired','expired',1,'<div style=\"background-color:white;\">\r\n\r\nh2. Session Expired\r\n\r\nYour session has expired due to inactivity.\r\n\r\nTo continue please login again.\r\n\r\n</div>',3,'2006-06-11 14:33:14','2007-01-30 12:50:56',NULL),(3,'Not Found!','notfound',1,'h1. Not Found\r\n\r\nThe page you requested was not found!\r\n\r\nPlease contact your system administrator.',3,'2006-06-11 14:33:49','2006-10-01 13:44:55',NULL),(4,'Permission Denied!','denied',1,'h1. Permission Denied\r\n\r\nSorry, but you don\'t have permission to view that page.\r\n\r\nPlease contact your system administrator.',3,'2006-06-11 14:34:30','2006-10-01 13:41:24',NULL),(6,'Contact Us','contact_us',1,'h1. Contact Us\r\n\r\nh2. Communication\r\n\r\nYou can get involved in the BioRails project at  \"www.biorails.com\":http://biorails.com site.  This is the __communications__ site provides a set of articles describing the product vision, the personas against which the product was developed and some related articles around the value of BioRails compared with other systems such as ELNs.  There is also a forum to discuss usage and technical aspects of the implementation as well as the usual FAQs.\r\n\r\nh2. Project Management\r\n\r\nFor the more technically minded visit the BioRails project site at  \"www.biorails.org\":http://biorails.org.  This is a Trac site used to support the design and implementation of the product.  The requirements, domain model, roadmap, time line and tickets can all be reviewed here.  You can also download a copy of the source code! \r\n',3,'2006-06-12 00:13:47','2006-12-11 22:15:27',NULL),(8,'Site Administration','site_admin',1,'h1. Goldberg Setup\r\n\r\nh2. Overview\r\n\r\nThis is where you will find all the Goldberg-specific administration and configuration features.  In here you can:\r\n\r\n* Set up Users.\r\n* Manage Roles and their Permissions.\r\n* Set up any Controllers and their Actions for your application.\r\n* Edit the Content Pages of the site.\r\n* Adjust Goldberg\'s system settings.\r\n\r\n<div style=\"float:left; padding-right:10px;\">\r\n\r\n!/images/setup_collection.jpg!\r\n\r\n</div>\r\n\r\nh2. Users\r\n\r\nYou can set up Users with a username, password and a Role.\r\n\r\nh2. Roles and Permissions\r\n\r\nA User\'s Permissions affect what Actions they can perform and what Pages they can see.  And because each Menu Item is based either on a Page or an Action, the Permissions determine what Menu Items the User can and cannot see.\r\n\r\nA Role is a set of Permissions.  Roles are assigned to Users.  Roles are hierarchical: a Role can have a parent Role; and if so it will inherit the Permissions of the parent Role, and all its parents.\r\n\r\nh2. Controllers and Actions\r\n\r\nTo execute any Action, a user must have the appropriate Permission.  Therefore all Controllers and Actions you set up for your Rails application need to be entered here, otherwise no user will be able to execute them.\r\n\r\nYou start by setting up the Controller and assigning it a Permission.  The Permission will be used as the default for any Actions invoked for that Controller.\r\n\r\nYou have the option of setting up specific Actions for the Controllers.  You would want to do that if the Action were to appear as a Menu Item, or if it were to have a different level of security to the default for the Controller.\r\n\r\nh2. Content Pages\r\n\r\nGoldberg has a very simple CMS built in.  You can create pages to be displayed on the site, possibly in menu items.\r\n\r\nh2. Menu Editor\r\n\r\nOnce you have set up your Controller Actions and Content Pages, you can put them into the site\'s menu using the Menu Editor.\r\n\r\nIn the Menu Editor you can add and remove Menu Items and move them around.  The security of a Menu Item (whether the user can see it or not) depends on the Permission of the Action or Page attached to that Menu Item.\r\n\r\nh2. System Settings\r\n\r\nGo here to view and edit the settings that determine how Goldberg operates.\r\n',1,'2006-06-21 11:32:35','2006-12-13 17:39:54',NULL),(10,'Credits and Licence','credits',1,'h1. Credits and Licence\r\n\r\nh2. BioRails\r\n\r\nh2. Goldberg\r\n\r\nGoldberg contains original material and third party material from various sources.\r\n\r\nAll original material is (p) Public Domain, No Rights Reserved.  Goldberg comes with no warranty whatsoever.\r\n\r\nThe copyright for any third party material remains with the original author, and the material is distributed here under the original terms.  \r\n\r\nMaterial has been selected from sources with licensing terms and conditions that allow use and redistribution for both personal and business purposes.  These licences include public domain, BSD-style licences, and Creative Commons licences (but *not* Creative Commons Non-Commercial).\r\n\r\nIf you are an author and you believe your copyrighted material has been included in Goldberg in breach of your licensing terms and conditions, please contact Dave Nelson (urbanus at 240gl dot org).\r\n\r\nh3. Other Features\r\n\r\nh4. Tabbed Panels\r\n\r\nGoldberg\'s implementation of tabbed panels was adapted from \r\n\"InternetConnection\":http://support.internetconnection.net/CODE_LIBRARY/Javascript_Show_Hide.shtml.',3,'2006-10-02 00:35:35','2006-12-13 12:46:34',NULL),(11,'Catalogue','Catalogue',1,'h1.  The Catalogue\r\n\r\nh2. Overview\r\n\r\n<div style=\"float:left;padding-right:10px;\">\r\n\r\n!/images/catalogue.jpg!\r\n\r\n</div>\r\n\r\nThe catalogue is a sophisticated and powerful dictionary management system.  From here conceptual namespaces can be defined, multiple systems linked in and ontologies can be mapped between the corporate standards and local usages.  The catalogue also provides the building blocks for the creation of studies and running experiments.\r\n\r\nh2. Tabs \r\n\r\nThe tabs are arranged in order of dependency, left to right:\r\n\r\nh3. \"Context\":/menu/catalog/context\r\n\r\nThe Context provides the conceptual namespaces for the BioRails implementations.  These namespaces are the terminologies used by the application when implemented in a particular domain such as pre-clinical research or a screening cascade.  Each discipline has its own terminologies and the catalogue provides a place to define these ontologies.  \r\n\r\nThe BioRails contexts can also be hierarchical which means that more complex dictionaries for cell lines and taxonomies can be supported.\r\n\r\nThe best way to use contexts is think of how the data would be used in an assay definition. \r\n\r\nh3. \"Systems\":/menu/catalog/systems\r\n\r\nAll the *data systems* linked into this instance of BioRails are listed in Systems. For each systems a number number of Data Element can be defined to link in lookup list of values for display and use in data entry. For example there could be a link to the internal compounds model and separate external enterprise level compound registration systems. \r\n\r\nh3. \"Parameter Types\":/menu/catalog/parameter_types\r\n\r\nParameter types are a __high-level__ global parameter definition used to classify a type of data captured and handled in the system. Studies may add there own aliases and formats to this to further characterise their results. For example there may be a global parameter EC50 which in a study is aliased to IC50. Or in other cases the parameter type of Compounds may be linked to difference source lists of valid values. \r\n\r\nh3. \"Parameter Roles\":/menu/catalog/roles\r\n\r\nThese are used to classify parameter type usage in a process. For example it may be a raw input value or a output of the process.\r\n\r\nh3. \"Study Stages\":/menu/catalog/stages\r\n\r\nStudy Stages are used to partition the protocols used in a study into a number of target stages to help with reporting and management. For example a screening cascade would have stages of  \r\n\r\n# Primary\r\n# Confirmation\r\n# Dose Response\r\n# Profile \r\n\r\nstages. In the study forms counts and summary statistics are presented in terms of these stages.\r\n\r\nh3. \"Data Types\":/menu/catalog/datatypes\r\n\r\nThese are types of data the systems understands. To add more data types some coding will be needed, but feel free to modify the name and description.  You have to understand what __Values Classes__ mean before changing them!\r\n\r\nh3. \"Data Formats\":/menu/catalog/formats\r\n\r\nBeyond here lies dragons and the land of perl programmers (they often come together!). This is where data formats can be defined in terms of __regular expressions__ linked to a data type. This is a powerful method of client field validation as seen in the data entry sheet. The regular expressions is tested after each key press in data entry in Javascript on the client.',3,'2006-10-09 09:40:09','2006-12-13 17:40:35',NULL),(12,'Inventory','Inventory',1,'h1. Inventory\r\n\r\nh2. Introduction\r\n\r\nInventory is what is tested (directly or indirectly) in studies.  Inventory can be anything from abstract compounds, batch references to physical, bar-coded samples or perhaps animals.  There are no assumptions made about what can be tested although the default set up is for compounds, batches and samples.\r\n\r\nBioRails supports multiple inventories from multiple sources (integrated through \"Systems\":/menu/catalog/systems in the \"Catalogue\":/menu/Catalogue).  This means that there may be internal inventory for the samples and plates created for the experiments, or external plate management systems linked in and made available for testing.  BioRails also supports interrelationships between inventory.  For example, There may be a number of batches available for a specific compound.\r\n\r\nh2. Tags\r\n\r\nh3. \"Overview\":/menu/inv/show\r\n\r\nThe overview will show a summary of all the different types of inventory, number of compounds, batches and plates/samples in each defined inventory for example.  There will also be information on the usage of the inventory.\r\n\r\n<div style=\"float:left;\">\r\n\r\n!/images/molecule.jpg!\r\n\r\n</div>\r\n\r\nh3. \"Compounds\":/menu/inv/compound\r\n\r\nCompounds are a window into an external compound registration system.  In this case \"ChemAxon\'s Marvin\":http://www.chemaxon.com/product/marvin_land.html has been used to generate images of the structure although any chemistry system can be mapped in.\r\n\r\nh3. \"Batches\":/menu/inv/batches\r\n\r\nThe batches associated with the compounds are listed here.  This is an internal (child) repository, part of BioRails which means that new Batches of compounds can be registered and existing ones updates or deleted. \r\n\r\nh3. \"Libraries\":/menu/inv/libraries\r\n\r\nThe term library in this context refers to a collection of compounds related by either structure or activity. Compound libraries originate from the field of combinatorial chemistry, a technique for synthesis of large volumes of structurally related compounds using an automated methodology.\r\n\r\nSome libraries are also compiled based on the activity of the compounds. They are typically supplied by reagent suppliers who will market a set of molecules for a particular application area. For example a Kinase Library. This can be a great starting point for a medicinal chemistry program or as the basis for a screening campaign based on a novel target.\r\n\r\nLibraries are also referred to as screening libraries. This is because the intended application of the library is to screen it for activity against a set of targets. Screening libraries are commercially available from library suppliers such as MayBridge. \r\n\r\n<div style=\"float:right;\">\r\n\r\n!/images/microtitre_plate.gif!\r\n\r\n</div>\r\n\r\nh3. \"Plates & Samples\":/menu/inv/containers\r\n\r\nPlates and Samples are of the type \"Container\".  A container should have a location and a quantity of substance within them.\r\n\r\nh3. \"Timeline\":/menu/inv/time\r\n\r\nChronological log of the changes to the inventory systems.\r\n\r\nh3. \"Reports\":/menu/inv/reports\r\n\r\nA collection of fixed reports that use inventory as an input parameter. \r\n\r\nh3. \"Notes\":/menu/inv/notes\r\n\r\nA collection of notes that apply to the inventory',3,'2006-10-09 09:42:23','2006-12-13 16:17:10',NULL),(14,'Study','Organisation',1,'h1. Study Management\r\n\r\nh2. The Study\r\n\r\nA study is a scientific investigation into the effect of a compound on a biological system. In BioRails, the study provides the required level of organisation for running experiments.  There will be one or more experiments run in a study.  The experiments will use protocols defined in the study.  These protocols are in turn built against the study terminology which is mapped to the corporate dictionaries. Each study will have its own collection of annotations and reports.  The objective is to provide not only a method of capturing biological data but to provide the basis for generating fixed reports, metrics, and most importantly, study reports.\r\n\r\n\r\n<div style=\"float:left; padding-right:10px;\">\r\n\r\n!/images/research_development.jpg!\r\n\r\n</div>\r\n\r\nh2. Organisation\r\n\r\nThe Study is organised into: \r\n \r\nh3. \"Overview\":/menu/org/study\r\n\r\nA list of studies each with metrics describing the number of parameters used, the number of protocols registered and experiments run.   \r\n\r\nh3. \"Parameters\":/menu/org/params\r\n\r\nParameters are the dictionaries against which protocols are built.  Each parameter has an assigned role is used to categorise them in reporting.  Each parameter has a unique name and is a type.  The parameters also have a unique alias which means that local/discipline terminologies can be used without conflicting with other research groups or the corporate dictionary.  Two good examples are:\r\n \r\n# __Dose__ , a common term with different meanings by different groups.  Dose in screening campaigns is usually linked to the type concentration, in animal experiments it is usually mass per unit weight.  The same term employed differently.\r\n# __xC50__,  there may be a number of implementations of the term IC50, such as EC50, IC-50, Each usage of the term is different but they can all be mapped to to the type xC50.  Different terms with the same meaning.          \r\n\r\nParameters assigned to the study will inherit the data type assigned to the Parameter Type.  The format provides form validation in the data entry sheets preventing mistakes being made on data entry. \r\n\r\nh3. \"Protocols\":/menu/org/protocol\r\n\r\nThe Protocols form shows a list of protocols available within the study.  Like Studies, protocols can be imported or experted as XML documents.  Editing the study allows the user to set up a data entry sheet.  Each row of the protocol is a __context__.  A context may be a physical container like a plate or rack, or an abstract entity such as a compound or a treatment group.  The context can be extended with child contexts.  In this way a treatment group may contain a collection of animals, a plate a collection of samples, each with a collection of wells. \r\n\r\nEach context supports a default number of rows. Parameters are dragged into each context  which will form the columns of the data entry sheet.  These columns can be populated with default values and made mandatory.\r\n  \r\nh3. \"Timeline\":/menu/org/time\r\n\r\nThe study Timeline provides a high level daily log of all the activities carried out in the study\r\n\r\nh3. \"Reports\":/menu/org/reports\r\n\r\nAny fixed reports that use *Study Name* as a parameter can be run directly from this tab.  Reports can also be defined here.\r\n\r\nh3. \"Notes\":/menu/org/notes\r\n\r\nA __table of contents__ of all the notes or annotations associated with the study, or elements of the study (such as experiments, protocols, compounds e.t.c.) can be viewed here.  ',1,'2006-12-11 21:59:22','2007-01-04 20:31:02',NULL),(16,'Experiment','Execution',1,'h1. Experiment\r\n\r\nh2. Overview\r\n\r\nAn experiment is the recording of __what happens__ when a process flow is executed.  It is best viewed as a collection of tasks where a protocol is run on one or more subjects (usually compounds) and returning a set of results with context.   \r\n\r\n<div style=\"float:left; padding-right:10px;\">\r\n\r\n!/images/lab_testing.jpg!\r\n\r\n</div>\r\n\r\nh2. Tags\r\n\r\nh3. \"Overview\":/menu/exec/experiment\r\n\r\nThe overview shows a list of experiments with their associated studies and a log of the tasks.\r\n\r\nh3. \"Schedule\":/menu/exec/setup\r\n\r\nThe schedule shows the schedule and ownership of tasks in an experiment. \r\n\r\nh3. \"Data Entry\":/menu/exec/data\r\n\r\nThe data entry sheet selects, presents the data entry sheet for the latest task assigned to the user or the one selected in the *Finder*\r\n',3,'2006-12-12 23:08:21','2006-12-13 23:35:33',NULL),(17,'Analysis & Reporting','Analysis_Introduction',1,'h1. Analysis & Reporting\r\n\r\nh2. Overview\r\n\r\nWith all the data stored in a structured database, BioRails offers powerful _ad-hoc_ analysis/data-mining capabilities to supplement the built-in reports for KPI/KQI and canned reports available from the reports tabs on each functional domain (\"Study/Reports\":/menu/org/reports, \"Inventory/Reports\":/menu/reports/ etc)\r\n\r\n<div style=\"float:left; padding-right:10px;\">\r\n!/images/human_brain.jpg!\r\n</div>\r\n\r\nh2. Objective\r\n\r\nThe objective is to provide a tool with which users can build a query and output a tabulated report to applications such as \"MS Excel\":http://office.microsoft.com/en-us/excel/default.aspx or \"Spotfire Decisionsite\":http://www.spotfire.com/.\r\n\r\nh3. Data Organisation\r\n\r\nThe data in BioRails is partitioned into studies, each with their own terminology/ontology but which maps into global \"parameter types\":/menu/catalog/parameter_types.  This means that the terms used in different studies can be handled consistently in queries and data mining.  In addition, data is captured against protocols built against these parameters providing a powerful method of organising and drilling into data.\r\n\r\nh3. Special Challenges\r\n\r\nh4. Pivoting\r\n\r\nOnce the correct data is identified by the scientist it needs to be pivoted correctly for the analysis tools.  This can be a major source of headaches for the analyst as many solutions require that the data is downloaded to the client and cleaned up before pivoting can occur.   It is important to provide some method of _in-situ_ pivoting so the data can be extracted in the correct format for the analysis tools.\r\n\r\n<div style=\"float:right;padding-left:10px;\">\r\n!/images/technical_design_elements.jpg!\r\n</div>\r\n\r\n\r\nh4. Unit Handling\r\n\r\nBioRails handles base units and conversion factors which means that queries can be run against dimensioned data without the worry of picking up values with different units.\r\n\r\nh3. Recording Analysis\r\n\r\nWell this should be deferred to analysis tools where possible.  However, the results of analysis should be stored.  This may be as a type of task or an annotation.\r\n\r\nh2. Key Analytical Reports\r\n\r\n# SAR: Structure Activity Relationship)\r\n# Compound Profile: Everything about that compound)\r\n# Pregression: Tracking the progression of compounds through the system\r\n# Patient Profile: Everything that has happened to the patient against which experiments were run (large animal/clinical) \r\n',3,'2007-01-04 16:47:53','2007-01-30 21:30:02',NULL),(18,'Study Report','Study_Report',1,'h1. Study Report\r\n\r\nh2. What is a Study Report\r\n\r\nA study report is a write up of a study.  This report is a mixture of \r\n\r\n# Tables of data extracted from the database\r\n# Graphics and charts of the data\r\n# Statistical Analysis of the data\r\n# The conclusions written by the responsible scientist (study director)\r\n\r\nh2. Generating a Study Report in BioRails\r\n\r\nBioRails has a host of features which helps the biologist generate a complete report...\r\n\r\nh3. Extracting Metrics & Results\r\n\r\n<div style=\"float:left;\">\r\n\r\n||\\6. *Usage of parameters by role as count (avg +/-2*stddev) [min..max] Parameter_role* ||\r\n||*Parameter_type* ||*Observation*|| *Result* || *Setting* || *Subject* || *Condition* ||\r\n||\\5. Dose 6#||7 (15.7143+/- 36.4216)||\r\n||Compound||23||45||22||3||26||\r\n||Phenotype||30||na||Wistar Hans||na||14||\r\n||Derived 2#||na||na||na||8 (26.8125+/- 53.0526)||3||\r\n\r\nTables of summary statistics or metrics can be regenerated in the report.  These statistics are live and will change with the underlying data so are always accurate at the point of refreshing the page.  *We may want to provide an automated refresh*.\r\n\r\nIndividual records can be retrieved or all the records in a task, or all the records at a certain level of the hierarchy as defined by the protocol\r\n\r\n</div>\r\n\r\nh2. Additional Rendering\r\n\r\nThe extracted data can be rendered in a number of different ways:\r\n\r\nh3. Plotted Data\r\n\r\nBioRails has a library of charting options.  These can be used to plot the data directly with no intermediate steps.\r\n\r\n!/charts/histogram/667! \r\n\r\nh3. Spreadsheet Output\r\n\r\nTo simplify the formatting of the report, the data can be output directly to a spreadsheet where it can be formatted _in-situ_ which is essential for scientists who do not know how to format their data until they extract it.\r\n\r\nh2. Secondary Analysis\r\n\r\nBioRails will provide an added level of analysis. for example fit charts and statistical reports could be generated as part of the output by adding the relevent plug-in.',3,'2007-01-04 20:55:12','2007-01-04 21:09:23',NULL),(19,'To Be Defined','TBD',1,'h1. TBD\r\n\r\nTo be defined.\r\n\r\n!/images/setup_collection.jpg!',3,'2007-01-04 21:12:27','2007-01-05 19:52:17',NULL),(20,'Requesting','Requesting',1,'h2. Requesting Overview\r\n\r\n!/images/workflow.png!',5,'2007-01-09 09:50:03','2007-03-06 11:07:09','<h2>Requesting Overview</h2>\n\n\n	<p><img src=\"/images/workflow.png\" alt=\"\" /></p>');
/*!40000 ALTER TABLE `content_pages` ENABLE KEYS */;

--
-- Table structure for table `controller_actions`
--

DROP TABLE IF EXISTS `controller_actions`;
CREATE TABLE `controller_actions` (
  `id` int(11) NOT NULL auto_increment,
  `site_controller_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `permission_id` int(11) default NULL,
  `url_to_use` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_controller_action_permission_id` (`permission_id`),
  KEY `fk_controller_action_site_controller_id` (`site_controller_id`),
  CONSTRAINT `fk_controller_action_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_controller_action_site_controller_id` FOREIGN KEY (`site_controller_id`) REFERENCES `site_controllers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `controller_actions`
--


/*!40000 ALTER TABLE `controller_actions` DISABLE KEYS */;
INSERT INTO `controller_actions` VALUES (1,1,'view_default',3,NULL),(2,1,'view',3,NULL),(3,7,'list',NULL,NULL),(4,6,'list',NULL,NULL),(5,3,'login',4,NULL),(6,3,'logout',4,NULL),(7,5,'link',4,NULL),(8,1,'list',NULL,NULL),(9,8,'list',NULL,NULL),(10,2,'list',NULL,NULL),(11,5,'list',NULL,NULL),(12,9,'list',NULL,NULL),(13,3,'forgotten',4,NULL),(14,3,'login_failed',4,NULL),(15,10,'list',NULL,NULL),(17,13,'list',NULL,NULL),(18,13,'show',NULL,NULL),(19,13,'edit',NULL,NULL),(20,13,'destroy',NULL,NULL),(21,13,'create',NULL,NULL),(22,13,'new',NULL,NULL),(23,14,'list',NULL,NULL),(24,14,'show',NULL,NULL),(25,14,'edit',NULL,NULL),(26,14,'create',NULL,NULL),(27,14,'create_child',NULL,NULL),(28,14,'destroy',NULL,NULL),(33,16,'edit',NULL,NULL),(34,16,'show',NULL,NULL),(35,16,'list',NULL,NULL),(36,16,'export',NULL,NULL),(37,16,'destroy',NULL,NULL),(38,16,'create',NULL,NULL),(39,16,'create_child',NULL,NULL),(40,14,'update',NULL,NULL),(41,13,'update',NULL,NULL),(42,13,'export',NULL,NULL),(43,14,'export',NULL,NULL),(44,17,'list',NULL,NULL),(45,17,'new',NULL,NULL),(46,17,'show',NULL,NULL),(47,17,'update',NULL,NULL),(48,17,'create',NULL,NULL),(49,17,'edit',NULL,NULL),(61,20,'list',NULL,NULL),(62,20,'edit',NULL,NULL),(63,20,'new',NULL,NULL),(64,20,'destroy',NULL,NULL),(65,22,'list',NULL,NULL),(66,22,'new',NULL,NULL),(67,22,'edit',NULL,NULL),(68,22,'destroy',NULL,NULL),(69,21,'list',NULL,NULL),(70,21,'edit',NULL,NULL),(71,21,'new',NULL,NULL),(72,21,'destroy',NULL,NULL),(85,26,'list',NULL,NULL),(86,26,'edit',NULL,NULL),(87,26,'new',NULL,NULL),(88,28,'list',NULL,NULL),(89,28,'edit',NULL,NULL),(90,28,'new',NULL,NULL),(91,27,'new',NULL,NULL),(92,27,'list',NULL,NULL),(93,27,'edit',NULL,NULL),(94,27,'destroy',NULL,NULL),(95,29,'list',NULL,NULL),(96,29,'edit',NULL,NULL),(97,29,'new',NULL,NULL),(98,29,'destroy',NULL,NULL),(99,29,'create',NULL,NULL),(100,29,'update',NULL,NULL),(101,30,'query',NULL,NULL),(102,31,'list',NULL,NULL),(103,31,'edit',NULL,NULL),(104,31,'new',NULL,NULL),(105,32,'show',NULL,NULL),(106,32,'edit',NULL,NULL),(107,32,'create',NULL,NULL),(108,32,'new',NULL,NULL),(109,32,'list',NULL,NULL),(110,32,'update',NULL,NULL),(111,32,'destroy',NULL,NULL),(112,32,'sheet',NULL,NULL),(114,33,'list',NULL,NULL),(115,33,'edit',NULL,NULL),(116,33,'new',NULL,NULL),(117,26,'protocols',NULL,NULL),(118,26,'parameters',NULL,NULL),(119,31,'show',NULL,NULL),(120,34,'list',NULL,NULL),(121,34,'new',NULL,NULL),(122,34,'update',NULL,NULL),(123,35,'list',NULL,NULL),(124,35,'edit',NULL,NULL),(125,35,'new',NULL,NULL),(126,35,'destroy',1,NULL),(127,36,'list',NULL,NULL),(128,26,'timeline',NULL,NULL),(129,40,'list',NULL,NULL),(130,40,'show',NULL,NULL),(131,38,'list',NULL,NULL),(132,37,'list',NULL,NULL),(133,41,'list',NULL,NULL),(134,31,'timeline',NULL,NULL),(138,44,'new',NULL,NULL),(139,44,'list',NULL,NULL),(140,44,'show',NULL,NULL),(141,44,'edit',NULL,NULL),(142,47,'new',NULL,NULL),(143,47,'list',NULL,NULL),(144,47,'destroy',NULL,NULL),(145,47,'edit',NULL,NULL),(146,48,'list',NULL,NULL),(147,48,'builder',NULL,NULL),(148,26,'reports',NULL,NULL),(149,49,'show',NULL,NULL),(150,49,'list',NULL,NULL),(151,49,'new',NULL,NULL),(152,49,'add',NULL,NULL),(153,49,'edit',NULL,NULL),(154,49,'destroy',NULL,NULL),(155,49,'remove',NULL,NULL),(156,31,'reports',NULL,NULL),(157,50,'show',NULL,NULL),(158,50,'list',NULL,NULL),(159,31,'import_file',4,NULL);
/*!40000 ALTER TABLE `controller_actions` ENABLE KEYS */;

--
-- Table structure for table `data_concepts`
--

DROP TABLE IF EXISTS `data_concepts`;
CREATE TABLE `data_concepts` (
  `id` int(11) NOT NULL auto_increment,
  `parent_id` int(11) default NULL,
  `name` varchar(50) NOT NULL default '',
  `data_context_id` int(11) NOT NULL default '0',
  `description` text,
  `access_control_id` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default 'sys',
  `created_at` datetime NOT NULL default '0000-00-00 00:00:00',
  `updated_by` varchar(32) NOT NULL default 'sys',
  `updated_at` datetime NOT NULL default '0000-00-00 00:00:00',
  `type` varchar(255) NOT NULL default 'DataConcept',
  PRIMARY KEY  (`id`),
  KEY `data_concepts_idx1` (`updated_by`),
  KEY `data_concepts_idx2` (`updated_at`),
  KEY `data_concepts_idx3` (`created_by`),
  KEY `data_concepts_idx4` (`created_at`),
  KEY `data_concepts_name_idx` (`name`),
  KEY `data_concepts_acl_idx` (`access_control_id`),
  KEY `data_concepts_fk1` (`data_context_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `data_concepts`
--


/*!40000 ALTER TABLE `data_concepts` DISABLE KEYS */;
INSERT INTO `data_concepts` VALUES (1,NULL,'BioRails',1,'This is the main <strong>context </strong>or<strong> conceptual name space </strong>for all key <strong>concepts </strong>in the core BioRails application. The context is divided into a logical tree of concepts.&nbsp; These concepts can be extended with child concepts providing&nbsp; the possibility of <strong>value lookup lists</strong> defined against each concept. In-use concepts<strong> </strong>are linked to <strong>parameter types </strong>at the global catalogue level. Parameter types are then implemented as <strong>study parameters</strong> and a linked lookup <strong>element </strong>may be used.<br />\r\n<br />\r\nThis structure provides a solid division of control between global warehousing need and local terminology, put more simply, the scientists can maintain their own (often unique) terminologies which can be mapped into the corporate dictionaries.',NULL,3,'sys','2007-01-22 15:23:29','sys','2007-01-23 20:54:17','DataContext'),(2,1,'Subject',1,'Subject',NULL,1,'sys','2006-09-06 19:33:33','sys','2006-09-06 19:33:33','DataConcept'),(3,1,'Study',1,'Study',NULL,1,'sys','2006-09-06 19:35:22','sys','2006-09-06 19:35:22','DataConcept'),(4,2,'Compound',1,'Compound Inventory',NULL,5,'sys','2006-09-06 19:35:33','sys','2006-10-09 16:01:50','DataConcept'),(5,2,'Batch',1,'Batch',NULL,1,'sys','2006-09-06 19:35:43','sys','2006-09-06 19:35:43','DataConcept'),(6,2,'Sample',1,'Sample',NULL,1,'sys','2006-09-06 19:35:50','sys','2006-09-06 19:35:51','DataConcept'),(7,2,'Container',1,'Container',NULL,2,'sys','2006-09-06 19:36:00','sys','2007-01-19 15:37:11','DataConcept'),(8,7,'Plate',1,'Plate',NULL,1,'sys','2006-09-06 19:36:07','sys','2006-09-06 19:36:07','DataConcept'),(9,7,'Rack',1,'Rack',NULL,1,'sys','2006-09-06 19:36:13','sys','2006-09-06 19:36:13','DataConcept'),(10,7,'Tube',1,'Tube',NULL,1,'sys','2006-09-06 19:36:24','sys','2006-09-06 19:36:24','DataConcept'),(11,7,'Tray',1,'Tray',NULL,2,'sys','2006-09-06 19:36:32','sys','2006-09-06 19:39:47','DataConcept'),(24,1,'Experiment',1,'Experiment main element in the execution of a workflow',NULL,1,'sys','2006-11-22 12:49:19','sys','2006-12-05 18:15:43','DataConcept'),(25,1,'Protocol',1,'Protocol',NULL,0,'sys','2006-11-22 12:52:00','sys','2006-11-22 12:52:00','DataConcept'),(26,1,'Unit',1,'Unit',NULL,0,'sys','2006-11-22 12:52:30','sys','2006-11-22 12:52:30','DataConcept'),(27,1,'Task',1,'Task',NULL,0,'sys','2006-11-22 12:53:17','sys','2006-11-22 12:53:17','DataConcept'),(28,1,'DataType',1,'Various type of data the system is expected to handle like numeric ,text',NULL,3,'sys','2006-11-22 12:53:47','sys','2007-01-22 23:32:32','DataConcept'),(29,1,'DataFormat',1,'Data Formats are skill',NULL,1,'sys','2006-11-22 12:56:05','sys','2007-01-12 13:58:05','DataConcept'),(30,1,'ParameterType',1,'ParameterType',NULL,0,'sys','2006-11-22 12:56:57','sys','2006-11-22 12:56:57','DataConcept'),(31,1,'ParameterRole',1,'Parameter Role',NULL,0,'sys','2006-11-22 12:57:18','sys','2006-11-22 12:57:18','DataConcept'),(33,1,'Times',1,'Timed Measurements',NULL,0,'sys','2006-12-12 13:53:02','sys','2006-12-12 13:53:02','DataConcept'),(39,1,'Lookup',1,'Lookup',NULL,0,'sys','2007-01-19 16:04:03','sys','2007-01-19 16:04:03','DataConcept'),(47,39,'Species',0,'Mammals licensed by company for pre-clinical safety studies',NULL,3,'sys','2007-01-31 13:51:33','sys','2007-03-20 15:57:04','DataConcept'),(48,1,'Users',0,'Allowed Username for people in the system',NULL,1,'sys','2007-02-28 17:55:48','sys','2007-02-28 17:55:48','DataConcept'),(49,39,'Flags',0,'Flags used for compound progression, quality control etc',NULL,1,'sys','2007-03-20 15:53:10','sys','2007-03-20 15:53:10','DataConcept');
/*!40000 ALTER TABLE `data_concepts` ENABLE KEYS */;

--
-- Table structure for table `data_contexts`
--

DROP TABLE IF EXISTS `data_contexts`;
CREATE TABLE `data_contexts` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL default '',
  `description` text,
  `access_control_id` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default 'sys',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default 'sys',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `data_contexts_idx1` (`updated_by`),
  KEY `data_contexts_idx2` (`updated_at`),
  KEY `data_contexts_idx3` (`created_by`),
  KEY `data_contexts_idx4` (`created_at`),
  KEY `data_contexts_name_idx` (`name`),
  KEY `data_contexts_acl_idx` (`access_control_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `data_contexts`
--


/*!40000 ALTER TABLE `data_contexts` DISABLE KEYS */;
INSERT INTO `data_contexts` VALUES (1,'BioRails','Main BIo Rails Context for application development namespace. This includes all the standard models and relationships in the default application setup',NULL,1,'sys','2006-09-06 19:28:02','sys','2006-12-05 18:10:03'),(2,'LegacyHTS','This is a example <em>namespace</em> for a custom integration of BioRails into a legacy inventory system.',NULL,2,'sys','2006-12-05 18:13:35','sys','2007-01-03 19:55:49');
/*!40000 ALTER TABLE `data_contexts` ENABLE KEYS */;

--
-- Table structure for table `data_elements`
--

DROP TABLE IF EXISTS `data_elements`;
CREATE TABLE `data_elements` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL default '',
  `description` text,
  `data_system_id` int(11) NOT NULL,
  `data_concept_id` int(11) NOT NULL,
  `access_control_id` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default 'sys',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default 'sys',
  `updated_at` datetime NOT NULL,
  `parent_id` int(10) unsigned default NULL,
  `style` varchar(10) NOT NULL,
  `content` text NOT NULL,
  `estimated_count` int(11) default NULL,
  `type` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `data_elements_idx1` (`updated_by`),
  KEY `data_elements_idx2` (`updated_at`),
  KEY `data_elements_idx3` (`created_by`),
  KEY `data_elements_idx4` (`created_at`),
  KEY `data_elements_name_idx` (`name`),
  KEY `data_elements_acl_idx` (`access_control_id`),
  KEY `data_element_fk2` (`data_concept_id`),
  KEY `data_element_fk1` (`data_system_id`),
  CONSTRAINT `data_element_fk2` FOREIGN KEY (`data_concept_id`) REFERENCES `data_concepts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `data_elements`
--


/*!40000 ALTER TABLE `data_elements` DISABLE KEYS */;
INSERT INTO `data_elements` VALUES (1,'Compound','Compound',1,4,NULL,7,'sys','2006-10-10 16:59:38','sys','2006-10-24 11:28:28',NULL,'sql','Compound',1000,'ModelElement'),(2,'Batch','Batch',1,5,NULL,6,'sys','2006-10-10 17:00:19','sys','2006-10-12 14:22:13',NULL,'sql','Select * from batches',12222,'SqlElement'),(8,'Plate','Plates',1,8,NULL,0,'sys','2006-10-24 14:03:15','sys','2006-10-24 14:03:15',NULL,'sql','plates',12,'ViewElement'),(45,'Studies','Studies on system',1,3,NULL,0,'sys','2007-01-19 16:08:38','sys','2007-01-19 16:08:38',NULL,'model','Study',4,'ModelElement'),(46,'Requests','Requests',1,39,NULL,0,'sys','2007-01-19 16:09:48','sys','2007-01-19 16:09:48',NULL,'model','QueueItem',9,'ModelElement'),(48,'Plates','List of Plates defined on the system',1,7,NULL,0,'sys','2007-01-23 09:21:03','sys','2007-01-23 09:21:03',NULL,'sql','select * from plates',0,'SqlElement'),(49,'COmpounds','Compounds Id as Sample Identifiers',1,7,NULL,0,'sys','2007-01-23 09:22:24','sys','2007-01-23 09:22:24',NULL,'sql','select * from compounds',1000,'SqlElement'),(56,'Route of Administration','Route of Administration',1,39,NULL,0,'sys','2007-01-31 13:48:35','sys','2007-01-31 13:48:35',NULL,'list','\'im\',\'iv\', \'ip\', \'po\', \'sc\'',5,'ListElement'),(57,'Sex','Male or female (not frequency!)',1,39,NULL,0,'sys','2007-01-31 13:49:55','sys','2007-01-31 13:49:55',NULL,'list','\'male\', \'female\'',2,'ListElement'),(63,'Mammals','Small Mammals',1,47,NULL,2,'sys','2007-01-31 14:35:09','sys','2007-03-20 15:57:59',NULL,'list','\'rat\', \'mouse\', \'guinea pig\', \'moose\'',4,'ListElement'),(64,'serum species ','Serum species used in DR-ELIZA study',1,39,NULL,0,'sys','2007-02-06 09:47:13','sys','2007-02-06 09:47:13',NULL,'list','\'Human\', \'Bovine\', \'Rat\', \'Mouse\', \'Guinea Pig\'',5,'ListElement'),(65,'Eliza Treatments','Eliza treamtments',1,39,NULL,0,'sys','2007-02-06 10:28:45','sys','2007-02-06 10:28:45',NULL,'list','\'AB ELISA - serum\', \'Tox - serum\', \'AB ELISA + serum\', \'Tox + serum\'',4,'ListElement'),(66,'Protocol','Protocols',1,25,NULL,0,'sys','2007-02-28 12:17:59','sys','2007-02-28 12:17:59',NULL,'model','StudyProtocol',9,'ModelElement'),(67,'Users','Internal users for the biorails systems',1,48,NULL,0,'sys','2007-02-28 17:56:19','sys','2007-02-28 17:56:19',NULL,'model','User',5,'ModelElement'),(69,'ParameterRoles','Parameter Usage Roles for extra classication of a data collected. This allow important results to be easily&nbsp; separated from&nbsp; setting, configuration and raw data saved back to the database.',1,31,NULL,0,'sys','2007-02-28 17:57:47','sys','2007-02-28 17:57:47',NULL,'model','ParameterRole',6,'ModelElement'),(70,'ParameterTypes','Internal Types of data managed',1,30,NULL,0,'sys','2007-02-28 17:58:07','sys','2007-02-28 17:58:07',NULL,'model','ParameterType',31,'ModelElement'),(71,'Compounds','Compounds as sample id',1,6,NULL,0,'sys','2007-02-28 17:58:55','sys','2007-02-28 17:58:55',NULL,'model','Compound',1002,'ModelElement'),(72,'Tasks','List of Tasks in the system',1,27,NULL,0,'sys','2007-02-28 17:59:15','sys','2007-02-28 17:59:15',NULL,'model','Task',19,'ModelElement'),(73,'Times','Times',1,33,NULL,0,'sys','2007-02-28 17:59:43','sys','2007-02-28 17:59:43',NULL,'list','0,1,2,3,4,5,10,15,20,25,30,40,50,100',14,'ListElement'),(74,'hours','hours',1,33,NULL,0,'sys','2007-02-28 18:00:43','sys','2007-02-28 18:00:43',NULL,'list','1,2,6,12,24,48',6,'ListElement'),(75,'Concentration','Simple Concentrations',1,26,NULL,0,'sys','2007-02-28 18:17:28','sys','2007-02-28 18:17:28',NULL,'list','\'Mol\',\'mMol\',\'uMol\',\'nMol\',\'pMol\',\'mg/kg\'',6,'ListElement'),(76,'Compound Role','What role does each compound take within an experiment',1,39,NULL,0,'sys','2007-03-08 06:58:48','sys','2007-03-08 06:58:48',NULL,'list','\'vehicle\',\'negative\',\'positive\',\'challenge\',\'interest\'',5,'ListElement'),(77,'Score','Score',1,39,NULL,1,'sys','2007-03-08 07:06:52','sys','2007-03-08 07:07:50',NULL,'list','0,1,2,3,4,5,6,7,8,9',9,'ListElement'),(80,'QC','pass, fail, retest',1,49,NULL,0,'sys','2007-03-20 15:54:30','sys','2007-03-20 15:54:30',NULL,'list','\'pass\',\'fail\',\'retest\'',3,'ListElement'),(81,'Progresssion','hit, miss, retest',1,49,NULL,0,'sys','2007-03-20 15:55:17','sys','2007-03-20 15:55:17',NULL,'list','\'hit\',\'miss\',\'retest\'',3,'ListElement'),(82,'KO','Concept \'knocked-out\' out is true',1,49,NULL,0,'sys','2007-03-20 15:56:19','sys','2007-03-20 15:56:19',NULL,'list','\'True\',\'False\'',2,'ListElement'),(83,'significance','NS to ****',1,49,NULL,0,'sys','2007-03-20 16:13:38','sys','2007-03-20 16:13:38',NULL,'list','\'NS\',\'*\',\'**\',\'***\',\'****\'',5,'ListElement'),(84,'Boolean','true or false',1,49,NULL,0,'sys','2007-03-20 21:25:37','sys','2007-03-20 21:25:37',NULL,'list','\'True\',\'False\'',2,'ListElement');
/*!40000 ALTER TABLE `data_elements` ENABLE KEYS */;

--
-- Table structure for table `data_environments`
--

DROP TABLE IF EXISTS `data_environments`;
CREATE TABLE `data_environments` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL default '',
  `description` text,
  `data_context_id` int(11) NOT NULL default '1',
  `access_control_id` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default 'sys',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default 'sys',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `data_environments_idx1` (`updated_by`),
  KEY `data_environments_idx2` (`updated_at`),
  KEY `data_environments_idx3` (`created_by`),
  KEY `data_environments_idx4` (`created_at`),
  KEY `data_environments_name_idx` (`name`),
  KEY `data_environments_acl_idx` (`access_control_id`),
  KEY `data_environments_fk1` (`data_context_id`),
  CONSTRAINT `data_environments_fk1` FOREIGN KEY (`data_context_id`) REFERENCES `data_contexts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `data_environments`
--


/*!40000 ALTER TABLE `data_environments` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_environments` ENABLE KEYS */;

--
-- Table structure for table `data_formats`
--

DROP TABLE IF EXISTS `data_formats`;
CREATE TABLE `data_formats` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `default_value` varchar(255) default NULL,
  `format_regex` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `data_type_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `data_formats`
--


/*!40000 ALTER TABLE `data_formats` DISABLE KEYS */;
INSERT INTO `data_formats` VALUES (1,'Text','Free Format Text','','.',1,'','0000-00-00 00:00:00','','2007-02-07 14:10:25',1),(2,'Alpha','A-Z',NULL,NULL,0,'','0000-00-00 00:00:00','','0000-00-00 00:00:00',1),(3,'Line','Single Line of Text',NULL,'/[^\"\\r\\n]*/',0,'','0000-00-00 00:00:00','','0000-00-00 00:00:00',1),(4,'Double','Standard Number format +/-nnn.nnnnn','0.0','^[-+]?[0-9]*\\.?[0-9]+$',2,'sys','2006-11-27 11:59:22','sys','2007-02-07 21:42:48',2),(5,'Hex','Nex values',NULL,'/\\b0[xX][0-9a-fA-F]+\\b/',0,'','0000-00-00 00:00:00','','0000-00-00 00:00:00',1),(6,'Float','Floating Point number',NULL,'/((\\b[0-9]+)?\\.)?[0-9]+\\b/',0,'','0000-00-00 00:00:00','','0000-00-00 00:00:00',2),(7,'Scientific Notation','Scientific Notation',NULL,'/[-+]?[0-9]*\\.?[0-9]+([eE][-+]?[0-9]+)?/',0,'','0000-00-00 00:00:00','','0000-00-00 00:00:00',2),(8,'Integer','Integer Value','','[-+]?\\b\\d+\\b',1,'','0000-00-00 00:00:00','','2007-02-07 14:10:37',2),(9,'Email','Email Address',NULL,'/^[A-Z0-9._%-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$/',0,'','0000-00-00 00:00:00','','0000-00-00 00:00:00',1),(10,'Date','Date yyyy-mm-dd',NULL,'/(19|20)\\d\\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])/',0,'','0000-00-00 00:00:00','','0000-00-00 00:00:00',3),(11,'Positive','Description:  	Positive integer value.\r\nMatches: 	123|||10|||54\r\nNon-Matches: 	-54|||54.234|||abc',NULL,'/^d$/',0,'','0000-00-00 00:00:00','','0000-00-00 00:00:00',2),(12,'Decimal5.2','Description:  	validates to 5 digits and 2 decimal places but not allowing zero\r\nMatches: 	12345.12|||0.5\r\nNon-Matches: 	123456.12|||1.234|||.1',NULL,'/(?!^0*$)(?!^0*\\.0*$)^\\d{1,5}(\\.\\d{1,2})?$/',0,'','0000-00-00 00:00:00','','0000-00-00 00:00:00',2),(13,'Percentage','Description:  	Percentage (From 0 to 100)\r\nMatches: 	100%|||100|||52.65%\r\nNon-Matches: 	-1|||-1%|||100.1%',NULL,'/(0*100{1,1}\\.?((?<=\\.)0*)?%?$)|(^0*\\d{0,2}\\.?((?<=\\.)\\d*)?%?)$/',0,'','0000-00-00 00:00:00','','0000-00-00 00:00:00',2),(14,'Dollars','Description:  	Regular expression for validating a US currency string field. Matches an unlimited number of digits to the left of an optional decimal point. Digits to the left of the decimal point can optionally be formatted with commas, in standard US currency format. If the decimal point is present, it must be followed by exactly two digits to the right. Matches an optional preceding dollar sign. Uses regex lookahead to preclude leading zeros and to match the optional formatting comma.\r\nMatches: 	$3,023,123.34|||9,876|||123456.78\r\nNon-Matches: 	0.002|||$01.00|||###1.00',NULL,'(?n:(^\\$?(?!0,?\\d)\\d{1,3}(?=(?<1>,)|(?<1>))(\\k<1>\\d{3})*(\\.\\d\\d)?)$)',0,'','0000-00-00 00:00:00','','0000-00-00 00:00:00',2),(15,'SSN','Description:  	This regular expression will match a hyphen-separated Social Security Number (SSN) in the format NNN-NN-NNNN.\r\nMatches: 	333-22-4444|||123-45-6789\r\nNon-Matches: 	123456789|||SSN',NULL,'/^\\d{3}-\\d{2}-\\d{4}$/',0,'','0000-00-00 00:00:00','','0000-00-00 00:00:00',1),(16,'CreditCard','Description:  	Updated on 7 Jun 2005 -- Matches major credit cards including: Visa (length 16, prefix 4); Mastercard (length 16, prefix 51-55); Diners Club/Carte Blanche (length 14, prefix 36, 38, or 300-305); Discover (length 16, prefix 6011); American Express (length 15, prefix 34 or 37). Saves the card type as a named group to facilitate further validation against a &quot;card type&quot; checkbox in a program. All 16 digit formats are grouped 4-4-4-4 with an optional hyphen or space between each group of 4 digits. The American Express format is grouped 4-6-5 with an optional hyphen or space between each group of digits. Formatting characters must be consistant, i.e. if two groups are separated by a hyphen, all groups must be separated by a hyphen for a match to occur.\r\nMatches: 	4111-2222-3333-4444|||3411 222222 33333|||5111222233334444\r\nNon-Matches: 	4111-2222-3333-444|||3411-2222-3333-4444|||Visa',NULL,'/^(?:(?<Visa>4\\d{3})|(?<Mastercard>5[1-5]\\d{2})|(?<Discover>6011)|(?<DinersClub>(?:3[68]\\d{2})|(?:30[0-5]\\d))|(?<AmericanExpress>3[47]\\d{2}))([ -]?)(?(DinersClub)(?:\\d{6}\\1\\d{4})|(?(AmericanExpress)(?:\\d{6}\\1\\d{5})|(?:\\d{4}\\1\\d{4}\\1\\d{4})))$/',0,'','0000-00-00 00:00:00','','0000-00-00 00:00:00',1),(17,'FullName','Description:  	Regular expression for validating a person\'s full name. Matches on two general formats: 1) first second third last (where first, second, and third names are optional and all present are separated by a space); 2) last, first second third (where second and third are optional, last is followed immediately by a comma and a space, and second, and third, if present, are separated by a space from each other and from first). First corresponds to surname and last corresponds to family name. Each name part is captured to a named group to facilitate program manipulation. Each name part must begin with an uppercase letter, followed by zero or more lowercase letters, except for the last name. Last name must begin with an uppercase letter, followed by one or more lowercase letters, but will match exceptions formatted like the following: McD..., MacD..., O\'R... Only format is validated, not spelling. NOTE: This regular expression uses positive and negative regex lookahead to determine the general format of the name, i.e. the presence or the absence of the comma determines the general format that will match. Furthermore, this initial version is not designed to accommodate titles and things like &quot;3rd&quot;.\r\nMatches: 	John Paul Jones|||Jones, John P|||Jones\r\nNon-Matches: 	Paul Jones, John|||John J|||Mr. John Paul Jones 3rd',NULL,'(?n:(^(?(?![^,]+?,)((?<first>[A-Z][a-z]*?) )?((?<second>[A-Z][a-z]*?) )?((?<third>[A-Z][a-z]*?) )?)(?<last>[A-Z]((\'|[a-z]{1,2})[A-Z])?[a-z]+))(?(?=,)(, (?<first>[A-Z][a-z]*?))?( (?<second>[A-Z][a-z]*?))?( (?<third>[A-Z][a-z]*?))?)$)',0,'','0000-00-00 00:00:00','','0000-00-00 00:00:00',1),(18,'DayTime','Description:  	Matches a string if it is a valid time in the format of HH:MM\r\nMatches: 	02:04|||16:56|||23:59\r\nNon-Matches: 	02:00 PM|||PM2:00|||24:00\r\n ',NULL,'/^([0-1][0-9]|[2][0-3]):([0-5][0-9])$/',0,'','0000-00-00 00:00:00','','0000-00-00 00:00:00',4),(19,'EngDate','Description:  	valid date base on Month\r\nMatches: 	01 Jan 2003\r\nNon-Matches: 	01 01 2003\r\n ',NULL,'/^\\d{2}\\s{1}(Jan|Feb|Mar|Apr|May|Jun|Jul|Apr|Sep|Oct|Nov|Dec)\\s{1}\\d{4}$/',0,'','0000-00-00 00:00:00','','0000-00-00 00:00:00',3),(20,'Time','Description:  	Validates Microsoft Project-type duration entries. Accepts a number and a unit. The number part can be integer or decimal. The unit can be several variations of weeks, days, and hours: e.g., w, wk, week, ws, wks, weeks are all valid. Whitespace between the number and the unit is optional: e.g., 1d, 2 days, 3.5w are all valid. Captures the number value in a group named num and the unit string in a group named \'unit\'.\r\nMatches: 	1 day|||3.5 w|||6hrs\r\nNon-Matches: 	1|||6. days|||1 week 2 d',NULL,'^\\s*(?\'num\'\\d+(\\.\\d+)?)\\s*(?\'unit\'((w(eek)?)|(wk)|(d(ay)?)|(h(our)?)|(hr))s?)(\\s*$)',0,'','0000-00-00 00:00:00','','0000-00-00 00:00:00',4),(21,'US-Phone','Description:  	US Phone Number: This regular expression for US phone numbers conforms to NANP A-digit and D-digit requirments (ANN-DNN-NNNN). Area Codes 001-199 are not permitted; Central Office Codes 001-199 are not permitted. Format validation accepts 10-digits without delimiters, optional parens on area code, and optional spaces or dashes between area code, central office code and station code. Acceptable formats include 2225551212, 222 555 1212, 222-555-1212, (222) 555 1212, (222) 555-1212, etc. You can add/remove formatting options to meet your needs.\r\nMatches: 	5305551212|||(530) 555-1212|||530-555-1212\r\nNon-Matches: 	0010011212|||1991991212|||123) not-good',NULL,'/^(?:\\([2-9]\\d{2}\\)\\ ?|[2-9]\\d{2}(?:\\-?|\\ ?))[2-9]\\d{2}[- ]?\\d{4}$/',0,'','0000-00-00 00:00:00','','0000-00-00 00:00:00',1),(22,'IP-Address','Description:  	RegExp for validating the format of IP Addresses. This works great with the ASP.NET RegularExpressionValidator server control.\r\nMatches: 	127.0.0.1|||255.255.255.0|||192.168.0.1\r\nNon-Matches: 	1200.5.4.3|||abc.def.ghi.jkl|||255.foo.bar.1\r\n ',NULL,'/^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9]',0,'','0000-00-00 00:00:00','','0000-00-00 00:00:00',1),(23,'URL-UK','Description:  	UK http/https/ftp URI. Based on my previous expression, this one takes an optional port number and optional trailing slash.\r\nMatches: 	http://www.zeropanic.co.uk/|||http://www.zeropanic.co.uk:81/|||http://www.zeropanic.co.uk:81\r\nNon-Matches: 	http://www.zeropanic.com:81/\r\n ',NULL,'/^(ht|f)tp((?<=http)s)?://((?<=http://)www|(?<=https://)www|(?<=ftp://)ftp)\\.(([a-z][0-9])|([0-9][a-z])|([a-z0-9][a-z0-9\\-]{1,2}[a-z0-9])|([a-z0-9][a-z0-9\\-](([a-z0-9\\-][a-z0-9])|([a-z0-9][a-z0-9\\-]))[a-z0-9\\-]*[a-z0-9]))\\.(co|me|org|ltd|plc|net|sch|ac|mo',0,'','0000-00-00 00:00:00','','0000-00-00 00:00:00',NULL),(24,'URL','Description:  	I wrote this after I couldn\'t find an expression that would search for valid URLs, whether they had HTTP in front or not. This will find those that don\'t have hyphens anywhere in them (except for after the domain).\r\nMatches: 	http://www.google.com|||www.123google.com|||www.google.com/help/me\r\nNon-Matches: 	-123google.com|||http://-123.123google.com\r\n ',NULL,'/^(?<link>((?<prot>http:\\/\\/)*(?<subdomain>(www|[^\\-\\n]*)*)(\\.)*(?<domain>[^\\-\\n]+)\\.(?<after>[a-zA-Z]{2,3}[^>\\n]*)))$/',0,'','0000-00-00 00:00:00','','0000-00-00 00:00:00',6);
/*!40000 ALTER TABLE `data_formats` ENABLE KEYS */;

--
-- Table structure for table `data_relations`
--

DROP TABLE IF EXISTS `data_relations`;
CREATE TABLE `data_relations` (
  `id` int(11) NOT NULL auto_increment,
  `from_concept_id` int(32) NOT NULL,
  `to_concept_id` int(32) NOT NULL,
  `role_concept_id` int(32) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `data_relations_from_idx` (`from_concept_id`),
  KEY `data_relations_to_idx` (`to_concept_id`),
  KEY `data_relations_role_idx` (`role_concept_id`),
  CONSTRAINT `data_relations_from_fk` FOREIGN KEY (`from_concept_id`) REFERENCES `data_concepts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `data_relations_role_fk` FOREIGN KEY (`role_concept_id`) REFERENCES `data_concepts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `data_relations_to_fk` FOREIGN KEY (`to_concept_id`) REFERENCES `data_concepts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `data_relations`
--


/*!40000 ALTER TABLE `data_relations` DISABLE KEYS */;
/*!40000 ALTER TABLE `data_relations` ENABLE KEYS */;

--
-- Table structure for table `data_systems`
--

DROP TABLE IF EXISTS `data_systems`;
CREATE TABLE `data_systems` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL default '',
  `description` text,
  `data_context_id` int(11) NOT NULL default '1',
  `access_control_id` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default 'sys',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default 'sys',
  `updated_at` datetime NOT NULL,
  `adapter` varchar(50) NOT NULL default 'mysql',
  `host` varchar(50) default 'localhost',
  `username` varchar(50) default 'root',
  `password` varchar(50) default '',
  `database` varchar(50) default '',
  `test_object` varchar(45) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `data_environments_idx1` (`updated_by`),
  KEY `data_environments_idx2` (`updated_at`),
  KEY `data_environments_idx3` (`created_by`),
  KEY `data_environments_idx4` (`created_at`),
  KEY `data_environments_name_idx` (`name`),
  KEY `data_environments_acl_idx` (`access_control_id`),
  KEY `data_environments_fk1` (`data_context_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `data_systems`
--


/*!40000 ALTER TABLE `data_systems` DISABLE KEYS */;
INSERT INTO `data_systems` VALUES (1,'Internal','Internal link to reference data element from with this BioRails schema',1,NULL,5,'sys','2006-10-09 12:11:25','sys','2007-01-13 21:46:14','mysql','localhost','biorails','moose','beagle_development','tmp_data');
/*!40000 ALTER TABLE `data_systems` ENABLE KEYS */;

--
-- Table structure for table `data_types`
--

DROP TABLE IF EXISTS `data_types`;
CREATE TABLE `data_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `value_class` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `data_types`
--


/*!40000 ALTER TABLE `data_types` DISABLE KEYS */;
INSERT INTO `data_types` VALUES (1,'text','Text','String',1,'','0000-00-00 00:00:00','','2006-12-13 16:44:12'),(2,'numeric','Numeric','Numeric',1,'','0000-00-00 00:00:00','','2006-12-13 16:44:21'),(3,'date','Date','Date',1,'','0000-00-00 00:00:00','','2006-12-13 16:44:28'),(4,'time','Time','DateTime',1,'','0000-00-00 00:00:00','','2006-12-13 16:44:35'),(5,'dictionary','Look up on catalogue','DataConcept',1,'','0000-00-00 00:00:00','','2006-12-13 16:44:41'),(6,'url','Reference','String',1,'','0000-00-00 00:00:00','','2006-12-13 16:44:50'),(7,'file','File','File',1,'','0000-00-00 00:00:00','','2006-12-13 16:45:26');
/*!40000 ALTER TABLE `data_types` ENABLE KEYS */;

--
-- Table structure for table `dead_process_definition`
--

DROP TABLE IF EXISTS `dead_process_definition`;
CREATE TABLE `dead_process_definition` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(30) NOT NULL,
  `release` varchar(5) NOT NULL,
  `description` text,
  `protocol_catagory` varchar(20) default NULL,
  `protocol_status` varchar(20) default NULL,
  `literature_ref` varchar(255) default NULL,
  `access_control_id` int(11) NOT NULL default '0',
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `process_definitions_name_index` (`name`),
  KEY `process_definitions_updated_by_index` (`updated_by`),
  KEY `process_definitions_updated_at_index` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `dead_process_definition`
--


/*!40000 ALTER TABLE `dead_process_definition` DISABLE KEYS */;
INSERT INTO `dead_process_definition` VALUES (17,'Define Materials','1','new protocol created for study Rat-Locomotion','Manual','Dev','',0,5,'','2006-12-13 19:47:05','','2006-12-16 19:19:50'),(18,'Treatment group setup','1','new protocol created for study Rat-Locomotion','Manual','Dev','',0,3,'','2006-12-13 19:52:29','','2006-12-13 21:07:35'),(19,'Rat information','1','new protocol created for study Rat-Locomotion','Manual','','',0,1,'','2006-12-13 19:54:50','','2006-12-13 19:55:50'),(20,'Randomisation','1','new protocol created for study Rat-Locomotion','Manual','','',0,2,'','2006-12-13 19:56:28','','2006-12-13 22:28:18'),(21,'Measure Activity','1','new protocol created for study Rat-Locomotion','Manual','Dev','',0,1,'','2006-12-13 20:11:43','','2006-12-13 20:16:26'),(22,'Activity measurement QC','1','Plot Activity vs Time for each animal  partitioned by  treatment group.','Graphical Analysis','Dev','',0,3,'','2006-12-13 20:19:28','','2006-12-13 20:30:42'),(23,'Time Binning','1','new protocol created for study Rat-Locomotion','Statistical Analysis','Dev','',0,1,'','2006-12-13 20:25:33','','2006-12-13 20:29:45'),(24,'Comparison of Means','1','Plot treatment groups against each other and support with a lateral whisker chart','Statistical Analysis','Dev','',0,4,'','2006-12-13 20:32:13','','2006-12-18 11:35:29'),(25,'ANOVA Results','1','new protocol created for study Rat-Locomotion','Statistical Analysis','Dev','',0,1,'','2006-12-13 20:38:25','','2006-12-13 20:44:16'),(26,'Define test materials','1','Behaviour - define the test materials','Manual','','',0,1,'','2006-12-14 12:42:59','','2006-12-14 12:50:16'),(27,'RL Material setup','2','Define the materials used in the experiment','Capture','','',0,18,'','2006-12-15 19:32:42','','2006-12-18 09:38:09'),(28,'RL Treatment-Group setup','1','Set up treatment group','Capture','','',0,8,'','2006-12-15 19:46:15','','2006-12-16 21:27:36'),(29,'RL Rat Information','1','new protocol created for study Behaviour','Capture','','',0,5,'','2006-12-15 19:53:57','','2006-12-15 20:35:12'),(30,'RL Randomise','1','new protocol created for study Behaviour','Capture','','',0,3,'','2006-12-15 19:58:59','','2006-12-15 20:35:30'),(31,'RL_RawData','1','new protocol created for study Behaviour','Capture','','',0,3,'','2006-12-15 20:01:53','','2006-12-15 20:33:19'),(32,'RL QC Imported Data','1','new protocol created for study Behaviour','Capture','','',0,4,'','2006-12-15 20:23:38','','2006-12-15 20:33:43'),(33,'RL Mean Comparison','1','new protocol created for study Behaviour','Report','','',0,2,'','2006-12-15 20:30:00','','2006-12-15 20:34:01'),(34,'RL Time Bin Analysis','1','new protocol created for study Behaviour','Report','','',0,2,'','2006-12-15 20:36:26','','2006-12-15 20:43:46'),(35,'RL ANOVA','1','new protocol created for study Behaviour','Report','','',0,1,'','2006-12-15 20:44:51','','2006-12-15 20:48:07'),(36,'TG Experiment Set-up','1','<meta content=\"text/html; charset=utf-8\" http-equiv=\"CONTENT-TYPE\" />\r\n<title></title>\r\n<meta content=\"OpenOffice.org 2.0  (Linux)\" name=\"GENERATOR\" /> 	 	 	<style type=\"text/css\">\r\n		<!-- \r\n		BODY,DIV,TABLE,THEAD,TBODY,TFOOT,TR,TH,TD,P { font-family:\"Arial\"; font-size:x-small }\r\n		 -->\r\n	</style>\r\n<table rules=\"none\" frame=\"void\" cols=\"1\" cellspacing=\"0\" border=\"0\">\r\n    <colgroup><col width=\"343\"></col></colgroup>\r\n    <tbody>\r\n        <tr>\r\n            <td width=\"343\" height=\"19\" align=\"left\"><font size=\"3\">Experiment: </font></td>\r\n        </tr>\r\n        <tr>\r\n            <td height=\"19\" align=\"left\"><font size=\"3\">Implant Date:</font></td>\r\n        </tr>\r\n        <tr>\r\n            <td height=\"19\" align=\"left\"><font size=\"3\">Tumor Type:   </font></td>\r\n        </tr>\r\n        <tr>\r\n            <td height=\"19\" align=\"left\"><font size=\"3\">Dosing: </font></td>\r\n        </tr>\r\n        <tr>\r\n            <td height=\"19\" align=\"left\"><font size=\"3\">Strain/Source:</font></td>\r\n        </tr>\r\n        <tr>\r\n            <td height=\"19\" align=\"left\"><font size=\"3\">Mean Tumor Size: </font></td>\r\n        </tr>\r\n        <tr>\r\n            <td height=\"19\" align=\"left\"><font size=\"3\">vehicle(s):</font></td>\r\n        </tr>\r\n        <tr>\r\n            <td height=\"19\" align=\"left\"><font size=\"3\">dosages:</font></td>\r\n        </tr>\r\n        <tr>\r\n            <td height=\"19\" align=\"left\"> </td>\r\n        </tr>\r\n    </tbody>\r\n</table>','Protocol','','',0,8,'','2006-12-16 11:01:17','','2006-12-16 21:19:08'),(37,'TG Data Capture','1','new protocol created for study Tumour Growth','Capture','','',0,3,'','2006-12-16 12:35:47','','2006-12-16 21:10:07'),(38,'Study Setup','1','new protocol created for study CR-EAE','Protocol','','',0,1,'','2006-12-19 13:13:55','','2006-12-19 14:17:53'),(39,'Treatment Group','','new protocol created for study CR-EAE','Protocol','','',0,2,'','2006-12-19 14:39:23','','2006-12-19 14:58:31'),(40,'Monitor','','new protocol created for study CR-EAE','Protocol','','',0,0,'','2006-12-19 15:03:41','','2006-12-19 15:03:41');
/*!40000 ALTER TABLE `dead_process_definition` ENABLE KEYS */;

--
-- Table structure for table `engine_schema_info`
--

DROP TABLE IF EXISTS `engine_schema_info`;
CREATE TABLE `engine_schema_info` (
  `engine_name` varchar(255) default NULL,
  `version` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `engine_schema_info`
--


/*!40000 ALTER TABLE `engine_schema_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `engine_schema_info` ENABLE KEYS */;

--
-- Table structure for table `experiment_logs`
--

DROP TABLE IF EXISTS `experiment_logs`;
CREATE TABLE `experiment_logs` (
  `id` int(11) NOT NULL auto_increment,
  `experiment_id` int(11) default NULL,
  `task_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `auditable_id` int(11) default NULL,
  `auditable_type` varchar(255) default NULL,
  `action` varchar(255) default NULL,
  `name` varchar(255) default NULL,
  `comment` varchar(255) default NULL,
  `created_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `experiment_logs_experiment_id_index` (`experiment_id`),
  KEY `experiment_logs_user_id_index` (`user_id`),
  KEY `experiment_logs_auditable_type_index` (`auditable_type`,`auditable_id`),
  KEY `experiment_logs_created_at_index` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `experiment_logs`
--


/*!40000 ALTER TABLE `experiment_logs` DISABLE KEYS */;
INSERT INTO `experiment_logs` VALUES (4,3,NULL,NULL,3,'Experiment','Create','TH210307-1',' Create study TH210307-1',NULL,'2007-03-21 15:08:03'),(5,3,NULL,NULL,2,'Task','Create','TH210307-1-0',' Create task TH210307-1-0 in experiment TH210307-1-0',NULL,'2007-03-21 15:08:27'),(6,3,NULL,NULL,2,'Task','Destroy','TH210307-1-0',' Destroy task TH210307-1-0 in experiment TH210307-1-0',NULL,'2007-03-21 15:09:09'),(7,3,NULL,NULL,3,'Task','Create','TH210307-1-0',' Create task TH210307-1-0 in experiment TH210307-1-0',NULL,'2007-03-21 15:09:44'),(8,3,NULL,NULL,4,'Task','Create','TH210307-1:1',' Create task TH210307-1:1 in experiment TH210307-1:1',NULL,'2007-03-21 15:33:53'),(9,3,NULL,NULL,4,'Task','Update','TH210307-1:1',' Update task TH210307-1:1 in experiment TH210307-1:1',NULL,'2007-03-21 15:33:53'),(10,3,NULL,NULL,3,'Task','Update','TH210307-1-0',' Update task TH210307-1-0 in experiment TH210307-1-0',NULL,'2007-03-21 15:34:15'),(11,3,NULL,NULL,3,'Task','Destroy','TH210307-1-0',' Destroy task TH210307-1-0 in experiment TH210307-1-0',NULL,'2007-03-21 15:42:34'),(12,3,NULL,NULL,4,'Task','Destroy','TH210307-1:1',' Destroy task TH210307-1:1 in experiment TH210307-1:1',NULL,'2007-03-21 15:42:51');
/*!40000 ALTER TABLE `experiment_logs` ENABLE KEYS */;

--
-- Temporary table structure for view `experiment_statistics`
--

DROP TABLE IF EXISTS `experiment_statistics`;
/*!50001 DROP VIEW IF EXISTS `experiment_statistics`*/;
/*!50001 CREATE TABLE `experiment_statistics` (
  `id` bigint(20),
  `experiment_id` int(11),
  `study_parameter_id` int(11),
  `parameter_role_id` int(11),
  `parameter_type_id` int(11),
  `data_type_id` int(11),
  `avg_values` double,
  `stddev_values` double,
  `num_values` bigint(20),
  `num_unique` bigint(20),
  `max_values` double,
  `min_values` double
) */;

--
-- Table structure for table `experiments`
--

DROP TABLE IF EXISTS `experiments`;
CREATE TABLE `experiments` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `category_id` int(11) default NULL,
  `status_id` varchar(255) default NULL,
  `study_id` int(11) default NULL,
  `protocol_version_id` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `study_protocol_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `experiments`
--


/*!40000 ALTER TABLE `experiments` DISABLE KEYS */;
INSERT INTO `experiments` VALUES (3,'TH210307-1',' Task in study RES Exposure ',NULL,NULL,2,10,0,'','2007-03-21 15:08:03','','2007-03-21 15:08:03',10);
/*!40000 ALTER TABLE `experiments` ENABLE KEYS */;

--
-- Table structure for table `list_items`
--

DROP TABLE IF EXISTS `list_items`;
CREATE TABLE `list_items` (
  `id` int(11) NOT NULL auto_increment,
  `list_id` int(11) default NULL,
  `data_type` varchar(255) default NULL,
  `data_id` int(11) default NULL,
  `data_name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `list_items`
--


/*!40000 ALTER TABLE `list_items` DISABLE KEYS */;
INSERT INTO `list_items` VALUES (1,5,'Compound',1,'AB001'),(2,5,'Compound',2,'AB002'),(3,5,'Compound',3,'AB003'),(4,6,'Compound',1,'AB001'),(5,6,'Compound',2,'AB002'),(6,6,'Compound',3,'AB003');
/*!40000 ALTER TABLE `list_items` ENABLE KEYS */;

--
-- Table structure for table `lists`
--

DROP TABLE IF EXISTS `lists`;
CREATE TABLE `lists` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` text,
  `type` varchar(255) default NULL,
  `expires_at` datetime default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `data_element_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lists`
--


/*!40000 ALTER TABLE `lists` DISABLE KEYS */;
INSERT INTO `lists` VALUES (1,'MyRequest',NULL,NULL,NULL,0,'','2007-03-04 05:56:29','','2007-03-04 05:56:29',1),(2,'MyRequest',NULL,NULL,NULL,0,'','2007-03-04 05:56:30','','2007-03-04 05:56:30',1),(3,'MyLib',NULL,NULL,NULL,0,'','2007-03-04 05:59:04','','2007-03-04 05:59:04',1),(4,'MyLib',NULL,NULL,NULL,0,'','2007-03-04 05:59:05','','2007-03-04 05:59:05',1),(5,'TH070321','Request TH070321','RequestList',NULL,0,'','2007-03-21 09:00:10','','2007-03-21 09:00:10',1),(6,'TH003','Request TH003','RequestList',NULL,0,'','2007-03-21 13:29:07','','2007-03-21 13:29:07',1);
/*!40000 ALTER TABLE `lists` ENABLE KEYS */;

--
-- Table structure for table `logging_events`
--

DROP TABLE IF EXISTS `logging_events`;
CREATE TABLE `logging_events` (
  `id` int(11) NOT NULL auto_increment,
  `level` varchar(255) default NULL,
  `source` varchar(255) default NULL,
  `class_ref` varchar(255) default NULL,
  `id_ref` varchar(255) default NULL,
  `name` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `comments` varchar(255) default NULL,
  `data` text,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `logging_events`
--


/*!40000 ALTER TABLE `logging_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `logging_events` ENABLE KEYS */;

--
-- Table structure for table `markup_styles`
--

DROP TABLE IF EXISTS `markup_styles`;
CREATE TABLE `markup_styles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `markup_styles`
--


/*!40000 ALTER TABLE `markup_styles` DISABLE KEYS */;
INSERT INTO `markup_styles` VALUES (1,'Textile'),(2,'Markdown'),(3,'text');
/*!40000 ALTER TABLE `markup_styles` ENABLE KEYS */;

--
-- Table structure for table `menu_items`
--

DROP TABLE IF EXISTS `menu_items`;
CREATE TABLE `menu_items` (
  `id` int(11) NOT NULL auto_increment,
  `parent_id` int(11) default NULL,
  `name` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `seq` int(11) default NULL,
  `controller_action_id` int(11) default NULL,
  `content_page_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_menu_item_controller_action_id` (`controller_action_id`),
  KEY `fk_menu_item_content_page_id` (`content_page_id`),
  KEY `fk_menu_item_parent_id` (`parent_id`),
  CONSTRAINT `fk_menu_item_content_page_id` FOREIGN KEY (`content_page_id`) REFERENCES `content_pages` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_menu_item_controller_action_id` FOREIGN KEY (`controller_action_id`) REFERENCES `controller_actions` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_menu_item_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `menu_items` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `menu_items`
--


/*!40000 ALTER TABLE `menu_items` DISABLE KEYS */;
INSERT INTO `menu_items` VALUES (1,NULL,'home','Home',1,NULL,1),(2,9,'contact_us','Contact Us',8,NULL,6),(5,9,'setup/permissions','Permissions',3,4,NULL),(6,9,'setup/roles','Roles',2,3,NULL),(7,9,'setup/pages','Content Pages',6,8,NULL),(8,9,'setup/controllers','Controllers',5,9,NULL),(9,NULL,'setup','Setup',6,NULL,8),(11,9,'setup/menus','Menu Editor',4,11,NULL),(12,9,'setup/system_settings','System Settings',7,12,NULL),(13,9,'setup/users','Users',1,15,NULL),(14,9,'credits','Credits',9,NULL,10),(15,NULL,'Catalogue','Catalogue',5,NULL,11),(16,NULL,'Inventory','Inventory',4,NULL,12),(17,NULL,'Organisation','Study',2,NULL,14),(18,NULL,'Execution','Experiment',3,NULL,16),(19,15,'catalog/list','Data Dictionary',1,150,NULL),(20,15,'catalog/formats','Data Formats',6,120,NULL),(21,15,'catalog/systems','Data Systems',2,44,NULL),(22,15,'catalog/datatype','Data Types',5,114,NULL),(26,17,'org/params','Parameters',2,118,NULL),(27,15,'catalog/parameter_types','Parameter Types',3,69,NULL),(28,17,'org/protocol','Protocols',3,117,NULL),(30,17,'org/study','Overview',1,85,NULL),(31,15,'catalog/stages','Study Stages',7,92,NULL),(34,18,'exe/experiment','Experiment',1,NULL,NULL),(35,18,'exec/experiment','Overview',2,102,NULL),(36,16,'inv/show','Overview',1,NULL,19),(38,16,'inv/notes','Notes',6,NULL,19),(39,15,'catalog/role','Parameter Roles',4,65,NULL),(40,17,'org/time','Timeline',6,128,NULL),(41,17,'org/reports','Reports',5,148,NULL),(42,17,'org/notes','Notes',4,NULL,19),(43,18,'exe/setup','Schedule',3,119,NULL),(44,18,'exe/data','Data Entry',4,106,NULL),(45,16,'inv/compound','Compounds',2,123,NULL),(46,16,'inv/batches','Batches',4,127,NULL),(47,16,'libraries','Libraries',3,NULL,19),(48,16,'containers','Plates & Samples',5,61,19),(49,16,'inv/time','Timeline',8,NULL,19),(50,16,'reports','Reports',7,NULL,19),(51,18,'experimentr/timeline','Timeline',7,134,NULL),(58,1,'Home/Requests','Requests',2,143,1),(59,1,'home/Requirements','Requirements',1,NULL,20),(61,18,'exp/reports','Reports',6,156,NULL),(62,18,'exp/notes','Notes',5,NULL,19),(63,15,'catalog/reports','Report Builder',8,146,NULL);
/*!40000 ALTER TABLE `menu_items` ENABLE KEYS */;

--
-- Table structure for table `parameter_contexts`
--

DROP TABLE IF EXISTS `parameter_contexts`;
CREATE TABLE `parameter_contexts` (
  `id` int(11) NOT NULL auto_increment,
  `protocol_version_id` int(11) default NULL,
  `parent_id` int(11) default NULL,
  `level_no` int(11) default '0',
  `label` varchar(255) default NULL,
  `default_count` int(11) default '1',
  PRIMARY KEY  (`id`),
  KEY `parameter_contexts_process_instance_id_index` (`protocol_version_id`),
  KEY `parameter_contexts_parent_id_index` (`parent_id`),
  KEY `parameter_contexts_label_index` (`label`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `parameter_contexts`
--


/*!40000 ALTER TABLE `parameter_contexts` DISABLE KEYS */;
INSERT INTO `parameter_contexts` VALUES (1,1,NULL,0,'Compounds',5),(2,2,NULL,0,'Settings',1),(3,2,2,0,'Animals',40),(5,3,NULL,0,'Treatment Groups',1),(6,3,5,0,'Treatments',3),(7,4,NULL,0,'Day',1),(8,4,7,0,'Animals',40),(9,5,NULL,0,'Treatment Groups',4),(10,5,9,0,'Day',8),(11,6,NULL,0,'Gene',3),(12,6,11,0,'Animals',40),(13,7,NULL,0,'Group',4),(14,8,NULL,0,'Group',1),(15,8,14,0,'Animals',10),(16,9,NULL,0,'Dose Groups',6),(17,10,NULL,0,'Groups',6),(18,10,17,0,'Animal',20),(19,11,NULL,0,'Compound',1),(20,11,19,0,'Dose Groups',6),(21,12,NULL,0,'Compound',1),(22,12,21,0,'Dose Group',3),(23,12,22,0,'Animals',4);
/*!40000 ALTER TABLE `parameter_contexts` ENABLE KEYS */;

--
-- Table structure for table `parameter_roles`
--

DROP TABLE IF EXISTS `parameter_roles`;
CREATE TABLE `parameter_roles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) NOT NULL,
  `weighing` int(11) NOT NULL default '0',
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `parameter_roles`
--


/*!40000 ALTER TABLE `parameter_roles` DISABLE KEYS */;
INSERT INTO `parameter_roles` VALUES (1,'observation','Measurement of the system under investigation',1,3,'sys','2006-10-26 15:34:14','sys','2006-12-13 16:43:21'),(2,'result','Summary data generated from the observations and other inputs',2,4,'sys','2006-10-26 15:34:25','sys','2006-12-13 16:43:32'),(3,'setting','Prefixed Setting',1,4,'sys','2006-10-26 15:34:38','sys','2006-12-13 16:43:39'),(4,'subject','Subject of Experiment',0,3,'sys','2006-10-26 15:35:05','sys','2006-12-13 16:43:47'),(6,'condition','Conditions under which the data is collected',1,3,'','2006-12-13 09:53:50','','2006-12-13 19:38:06'),(7,'note','annotation',0,0,'','2006-12-14 10:36:19','','2006-12-14 10:36:19');
/*!40000 ALTER TABLE `parameter_roles` ENABLE KEYS */;

--
-- Table structure for table `parameter_types`
--

DROP TABLE IF EXISTS `parameter_types`;
CREATE TABLE `parameter_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) NOT NULL,
  `weighing` int(11) NOT NULL default '0',
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL,
  `updated_at` datetime NOT NULL,
  `data_concept_id` int(11) default NULL,
  `data_type_id` int(11) default NULL,
  `storage_unit` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `parameter_types`
--


/*!40000 ALTER TABLE `parameter_types` DISABLE KEYS */;
INSERT INTO `parameter_types` VALUES (1,'Label','Text - used for labels, well ref etc',0,0,'','2007-03-20 14:13:11','','2007-03-20 14:13:11',NULL,1,NULL),(2,'Note','Textual note',0,0,'','2007-03-20 14:13:50','','2007-03-20 14:13:50',NULL,1,NULL),(3,'Activity','Normalised data used in screening for example',0,0,'','2007-03-20 14:14:31','','2007-03-20 14:14:31',NULL,2,NULL),(4,'Statistic','Derived numerical statistic',0,0,'','2007-03-20 14:14:55','','2007-03-20 14:14:55',NULL,2,NULL),(5,'Index','Used as a key in tables',0,0,'','2007-03-20 14:15:12','','2007-03-20 14:15:12',NULL,2,NULL),(6,'Counts','CPM, Behavioral counts etc',0,0,'','2007-03-20 14:15:39','','2007-03-20 14:15:39',NULL,2,NULL),(7,'Measure','A double, physical measurement',0,0,'','2007-03-20 14:16:03','','2007-03-20 14:16:03',NULL,2,NULL),(8,'Fit Statistic','Statistics generated from fitting activities',0,0,'','2007-03-20 14:16:30','','2007-03-20 14:16:30',NULL,2,NULL),(9,'Concentration','Concentration (not dose)',0,0,'','2007-03-20 14:16:57','','2007-03-20 14:16:57',NULL,2,NULL),(10,'Dose','Dose (Not concentration)',0,0,'','2007-03-20 14:18:14','','2007-03-20 14:18:14',NULL,2,NULL),(11,'Correction Factor','Numeric facture used to adjust data',0,0,'','2007-03-20 14:18:36','','2007-03-20 14:18:36',NULL,2,NULL),(12,'Sample Size','Integer - size of treatment group, number of obs etc',0,0,'','2007-03-20 14:19:04','','2007-03-20 14:19:04',NULL,2,NULL),(13,'Link','Link, URL pathname',0,0,'','2007-03-20 14:59:55','','2007-03-20 14:59:55',NULL,6,NULL),(14,'Calculation','Calculated Value',0,0,'','2007-03-20 15:00:50','','2007-03-20 15:00:50',NULL,2,NULL),(15,'Sex','Sex - dictionary (lookup)',0,0,'','2007-03-20 15:01:35','','2007-03-20 15:01:35',39,5,NULL),(16,'Route of Administration','Route of administration - dictionary',0,0,'','2007-03-20 15:02:13','','2007-03-20 15:02:13',39,5,NULL),(17,'Species','Species - dictionary (lookup)',0,1,'','2007-03-20 15:02:41','','2007-03-20 15:58:56',47,5,NULL),(18,'Flag','QC, progression and KO flags',0,0,'','2007-03-20 15:59:28','','2007-03-20 15:59:28',49,5,NULL),(19,'Treatment Role','Role of treatment - vehicle, subject etc',0,0,'','2007-03-20 16:00:18','','2007-03-20 16:00:18',39,5,NULL),(20,'Score','Scored values 1..10',0,0,'','2007-03-20 16:00:58','','2007-03-20 16:00:58',39,5,NULL),(21,'Date','Date',0,0,'','2007-03-20 16:01:14','','2007-03-20 16:01:14',NULL,3,NULL),(22,'Time','Time (hh:mm:ss) of observation',0,0,'','2007-03-20 16:01:40','','2007-03-20 16:01:40',NULL,4,NULL),(23,'Compound','Compound under investigation',0,0,'','2007-03-20 16:23:42','','2007-03-20 16:23:42',4,5,NULL);
/*!40000 ALTER TABLE `parameter_types` ENABLE KEYS */;

--
-- Table structure for table `parameters`
--

DROP TABLE IF EXISTS `parameters`;
CREATE TABLE `parameters` (
  `id` int(11) NOT NULL auto_increment,
  `protocol_version_id` int(11) default NULL,
  `parameter_type_id` int(11) default NULL,
  `parameter_role_id` int(11) default NULL,
  `parameter_context_id` int(11) default NULL,
  `column_no` int(11) default NULL,
  `sequence_num` int(11) default NULL,
  `name` varchar(62) default NULL,
  `description` varchar(62) default NULL,
  `display_unit` varchar(20) default NULL,
  `data_element_id` int(11) default NULL,
  `qualifier_style` varchar(1) default NULL,
  `access_control_id` int(11) NOT NULL default '0',
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `mandatory` varchar(255) default 'N',
  `default_value` varchar(255) default NULL,
  `data_type_id` int(11) default NULL,
  `data_format_id` int(11) default NULL,
  `study_parameter_id` int(11) default NULL,
  `study_queue_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `parameters_name_index` (`name`),
  KEY `parameters_process_instance_id_index` (`protocol_version_id`),
  KEY `parameters_parameter_context_id_index` (`parameter_context_id`),
  KEY `parameters_parameter_type_id_index` (`parameter_type_id`),
  KEY `parameters_parameter_role_id_index` (`parameter_role_id`),
  KEY `parameters_updated_by_index` (`updated_by`),
  KEY `parameters_updated_at_index` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `parameters`
--


/*!40000 ALTER TABLE `parameters` DISABLE KEYS */;
INSERT INTO `parameters` VALUES (1,1,23,4,1,1,0,'Compounds',NULL,NULL,1,NULL,0,4,'','2007-03-20 20:02:01','','2007-03-21 14:27:55',NULL,'',5,NULL,15,15),(5,1,1,6,1,2,0,'Molecula Formula',NULL,NULL,NULL,NULL,0,5,'','2007-03-20 20:02:40','','2007-03-21 14:27:55','Y','',1,1,14,NULL),(6,1,7,6,1,3,0,'Molecular Mass',NULL,NULL,NULL,NULL,0,5,'','2007-03-20 20:02:44','','2007-03-21 14:27:54','Y','',2,4,11,NULL),(7,2,17,3,2,1,0,'Species',NULL,NULL,63,NULL,0,3,'','2007-03-20 20:05:44','','2007-03-20 20:06:56',NULL,'',5,NULL,19,NULL),(8,2,1,3,2,2,0,'Strain',NULL,NULL,NULL,NULL,0,3,'','2007-03-20 20:05:49','','2007-03-20 20:06:56',NULL,'',1,1,22,NULL),(9,2,7,3,2,3,0,'Min Age',NULL,NULL,NULL,NULL,0,3,'','2007-03-20 20:05:56','','2007-03-20 20:06:56',NULL,'',2,8,13,NULL),(10,2,7,3,2,4,0,'Min Weight',NULL,NULL,NULL,NULL,0,3,'','2007-03-20 20:05:58','','2007-03-20 20:06:56',NULL,'',2,4,12,NULL),(11,2,5,3,3,5,0,'Index',NULL,NULL,NULL,NULL,0,3,'','2007-03-20 20:06:17','','2007-03-20 20:07:56','Y','',2,8,7,NULL),(12,2,1,3,3,6,0,'ID',NULL,NULL,NULL,NULL,0,3,'','2007-03-20 20:06:21','','2007-03-20 20:07:56','Y','',1,1,21,NULL),(13,2,7,6,3,7,0,'Age',NULL,NULL,NULL,NULL,0,3,'','2007-03-20 20:06:24','','2007-03-20 20:07:56','Y','',2,8,18,NULL),(14,2,7,1,3,8,0,'Initial Weight',NULL,NULL,NULL,NULL,0,3,'','2007-03-20 20:06:31','','2007-03-20 20:07:56','Y','',2,4,2,NULL),(15,2,1,3,3,9,0,'Treatment Group',NULL,NULL,NULL,NULL,0,3,'','2007-03-20 20:06:41','','2007-03-20 20:07:56','Y','',1,1,8,NULL),(16,3,5,3,5,1,0,'Index',NULL,NULL,NULL,NULL,0,3,'','2007-03-20 20:09:36','','2007-03-20 20:11:06','Y','',2,8,7,NULL),(17,3,1,3,5,2,0,'ID',NULL,NULL,NULL,NULL,0,3,'','2007-03-20 20:09:40','','2007-03-20 20:11:06','Y','',1,1,21,NULL),(18,3,12,6,5,3,0,'Group Size',NULL,NULL,NULL,NULL,0,3,'','2007-03-20 20:09:46','','2007-03-20 20:11:06','Y','',2,8,9,NULL),(19,3,7,1,5,4,0,'Mean Weight',NULL,NULL,NULL,NULL,0,3,'','2007-03-20 20:09:51','','2007-03-20 20:11:06','Y','',2,4,2,NULL),(20,3,19,3,6,5,0,'Treatment Role',NULL,NULL,76,NULL,0,4,'','2007-03-20 20:10:02','','2007-03-20 20:11:14','Y','',5,NULL,6,NULL),(23,4,7,6,7,1,0,'Day',NULL,NULL,NULL,NULL,0,3,'','2007-03-20 20:56:25','','2007-03-20 20:57:24',NULL,'',2,8,20,NULL),(24,4,1,3,8,2,0,'ID',NULL,NULL,NULL,NULL,0,3,'','2007-03-20 20:56:38','','2007-03-20 20:57:11',NULL,'',1,1,21,NULL),(25,4,7,1,8,3,0,'Weight',NULL,NULL,NULL,NULL,0,3,'','2007-03-20 20:56:52','','2007-03-20 20:57:11',NULL,'',2,4,2,NULL),(26,5,1,3,9,1,0,'Treatment Group',NULL,NULL,NULL,NULL,0,3,'','2007-03-20 21:01:34','','2007-03-20 21:11:35',NULL,'',1,1,8,NULL),(57,5,7,1,10,4,0,'Mean Weight',NULL,NULL,NULL,NULL,0,5,'','2007-03-20 21:12:12','','2007-03-21 14:32:32',NULL,'',2,4,2,NULL),(58,5,7,1,10,5,1,'SD Weight',NULL,NULL,NULL,NULL,0,5,'','2007-03-20 21:12:16','','2007-03-21 14:32:32',NULL,'',2,4,2,NULL),(59,6,1,3,11,1,0,'Gene',NULL,NULL,NULL,NULL,0,3,'','2007-03-20 21:16:39','','2007-03-20 21:18:00',NULL,'',1,1,10,NULL),(64,7,1,3,13,1,0,'Treatment Group',NULL,NULL,NULL,NULL,0,3,'','2007-03-20 21:23:00','','2007-03-20 21:26:59',NULL,'',1,1,8,NULL),(65,7,4,2,13,2,0,'p',NULL,NULL,NULL,NULL,0,3,'','2007-03-20 21:23:03','','2007-03-20 21:26:59',NULL,'',2,4,4,NULL),(66,7,18,2,13,3,0,'sig',NULL,NULL,80,NULL,0,3,'','2007-03-20 21:23:07','','2007-03-20 21:26:59',NULL,'',5,NULL,5,NULL),(67,7,18,2,13,4,0,'Histology',NULL,NULL,80,NULL,0,3,'','2007-03-20 21:26:38','','2007-03-20 21:26:59',NULL,'',5,NULL,25,NULL),(68,6,1,3,12,2,0,'ID',NULL,NULL,NULL,NULL,0,5,'','2007-03-20 21:28:47','','2007-03-20 21:29:00','N',NULL,1,1,21,16),(69,6,3,1,12,3,0,'Reading',NULL,NULL,NULL,NULL,0,2,'','2007-03-20 21:29:04','','2007-03-20 21:29:04','N',NULL,2,4,3,NULL),(70,6,3,1,12,4,1,'Reading_1',NULL,NULL,NULL,NULL,0,2,'','2007-03-20 21:29:06','','2007-03-20 21:29:06','N',NULL,2,4,3,NULL),(76,8,1,3,14,1,0,'Treatment Group',NULL,NULL,NULL,NULL,0,3,'','2007-03-20 21:34:44','','2007-03-20 21:35:16',NULL,'',1,1,8,17),(77,8,1,3,15,2,0,'Animal ID',NULL,NULL,NULL,NULL,0,4,'','2007-03-20 21:35:23','','2007-03-20 21:38:29',NULL,'',1,1,21,NULL),(78,8,20,1,15,3,0,'Cellular Infiltration',NULL,NULL,77,NULL,0,4,'','2007-03-20 21:35:26','','2007-03-20 21:38:29',NULL,'',5,NULL,1,NULL),(79,8,20,1,15,4,1,'Edema',NULL,NULL,77,NULL,0,4,'','2007-03-20 21:35:29','','2007-03-20 21:38:29',NULL,'',5,NULL,1,NULL),(80,8,20,1,15,5,2,'Hyperplasia',NULL,NULL,77,NULL,0,4,'','2007-03-20 21:35:32','','2007-03-20 21:38:29',NULL,'',5,NULL,1,NULL),(81,8,20,1,15,6,3,'Macrophage',NULL,NULL,77,NULL,0,4,'','2007-03-20 21:35:35','','2007-03-20 21:38:29',NULL,'',5,NULL,1,NULL),(88,9,5,3,16,1,0,'DoseGroupID',NULL,NULL,NULL,NULL,0,6,'','2007-03-21 09:54:06','','2007-03-21 14:47:35',NULL,'',2,8,26,NULL),(89,9,1,6,16,2,0,'DRUG',NULL,NULL,NULL,NULL,0,6,'','2007-03-21 09:54:18','','2007-03-21 14:47:35',NULL,'',1,1,30,NULL),(90,9,19,6,16,3,0,'Treatment Role',NULL,NULL,76,NULL,0,6,'','2007-03-21 09:54:23','','2007-03-21 14:47:35',NULL,'',5,NULL,31,NULL),(91,9,23,4,16,4,0,'Compound',NULL,NULL,1,NULL,0,6,'','2007-03-21 09:54:35','','2007-03-21 14:47:35',NULL,'',5,NULL,29,18),(92,9,9,6,16,5,0,'Concentration',NULL,NULL,NULL,NULL,0,6,'','2007-03-21 09:54:40','','2007-03-21 14:47:35',NULL,'',2,4,32,NULL),(93,9,23,4,16,6,1,'Vehicle',NULL,NULL,1,NULL,0,6,'','2007-03-21 09:54:48','','2007-03-21 14:47:35',NULL,'',5,NULL,29,NULL),(94,9,12,3,16,7,0,'Group Size',NULL,NULL,NULL,NULL,0,6,'','2007-03-21 09:55:07','','2007-03-21 14:47:35',NULL,'20',2,4,33,NULL),(95,10,5,3,17,1,0,'DoseGroupID',NULL,NULL,NULL,NULL,0,3,'','2007-03-21 10:07:41','','2007-03-21 10:08:28','Y','',2,8,26,NULL),(96,10,1,6,17,2,0,'DRUG',NULL,NULL,NULL,NULL,0,3,'','2007-03-21 10:07:49','','2007-03-21 10:08:28','Y','',1,1,30,NULL),(97,10,5,3,18,3,0,'Box',NULL,NULL,NULL,NULL,0,7,'','2007-03-21 10:09:27','','2007-03-21 11:11:40','Y','',2,8,26,NULL),(98,10,5,3,18,4,1,'AnimalNo',NULL,NULL,NULL,NULL,0,7,'','2007-03-21 10:09:30','','2007-03-21 11:11:40','Y','',2,8,26,NULL),(99,10,22,6,18,5,0,'StartTime',NULL,NULL,NULL,NULL,0,7,'','2007-03-21 10:09:41','','2007-03-21 11:11:40','Y','',4,20,27,NULL),(100,10,6,1,18,6,0,'Total',NULL,NULL,NULL,NULL,0,7,'','2007-03-21 10:09:52','','2007-03-21 11:11:40',NULL,'',2,8,28,NULL),(101,10,6,1,18,7,1,'5 min',NULL,NULL,NULL,NULL,0,7,'','2007-03-21 10:10:05','','2007-03-21 11:11:40','Y','',2,8,28,NULL),(102,10,6,1,18,8,2,'10 min',NULL,NULL,NULL,NULL,0,7,'','2007-03-21 10:10:08','','2007-03-21 11:11:40','Y','',2,8,28,NULL),(103,10,6,1,18,9,3,'15 min',NULL,NULL,NULL,NULL,0,7,'','2007-03-21 10:10:13','','2007-03-21 11:11:40','Y','',2,8,28,NULL),(104,10,6,1,18,10,4,'20 min',NULL,NULL,NULL,NULL,0,7,'','2007-03-21 10:10:18','','2007-03-21 11:11:40',NULL,'',2,8,28,NULL),(105,10,6,1,18,11,5,'25 min',NULL,NULL,NULL,NULL,0,7,'','2007-03-21 10:10:20','','2007-03-21 11:11:40',NULL,'',2,8,28,NULL),(106,10,6,1,18,12,6,'30 min',NULL,NULL,NULL,NULL,0,7,'','2007-03-21 10:10:26','','2007-03-21 11:11:40',NULL,'',2,8,28,NULL),(108,10,6,1,18,13,0,'15 min recording',NULL,NULL,NULL,NULL,0,5,'','2007-03-21 10:12:59','','2007-03-21 11:11:40','Y','',2,8,28,NULL),(114,11,23,4,19,1,0,'Compound',NULL,NULL,1,NULL,0,4,'','2007-03-21 11:00:46','','2007-03-21 11:13:50',NULL,'',5,NULL,29,18),(115,11,8,2,19,2,0,'ED50',NULL,NULL,NULL,NULL,0,4,'','2007-03-21 11:09:31','','2007-03-21 11:13:50',NULL,'',2,4,35,NULL),(116,11,13,2,19,3,0,'Fit Report',NULL,NULL,NULL,NULL,0,4,'','2007-03-21 11:09:34','','2007-03-21 11:13:50',NULL,'',6,24,36,NULL),(117,11,3,2,19,4,0,'Max Inhibition',NULL,NULL,NULL,NULL,0,4,'','2007-03-21 11:09:37','','2007-03-21 11:13:50',NULL,'',2,12,34,NULL),(118,11,9,6,19,5,0,'Max Inhibition Conc',NULL,NULL,NULL,NULL,0,4,'','2007-03-21 11:09:41','','2007-03-21 11:13:50',NULL,'',2,4,32,NULL),(119,11,5,3,20,6,0,'DoseGroupID',NULL,NULL,NULL,NULL,0,4,'','2007-03-21 11:10:45','','2007-03-21 11:19:16',NULL,'',2,8,26,NULL),(124,11,19,6,20,7,0,'Treatment Role',NULL,NULL,76,NULL,0,3,'','2007-03-21 11:13:07','','2007-03-21 11:19:17',NULL,'',5,NULL,31,NULL),(125,11,9,6,20,8,0,'Concentration',NULL,NULL,NULL,NULL,0,3,'','2007-03-21 11:13:15','','2007-03-21 11:19:17',NULL,'',2,4,32,NULL),(131,11,4,2,20,9,0,'Mean Activity Count',NULL,NULL,NULL,NULL,0,3,'','2007-03-21 11:16:48','','2007-03-21 11:19:16',NULL,'',2,4,37,NULL),(132,11,3,2,20,10,0,'Mean Inhibition',NULL,NULL,NULL,NULL,0,3,'','2007-03-21 11:16:52','','2007-03-21 11:19:17',NULL,'',2,12,34,NULL),(133,11,3,2,20,11,1,'SD Inhibition',NULL,NULL,NULL,NULL,0,3,'','2007-03-21 11:16:58','','2007-03-21 11:19:17',NULL,'',2,12,34,NULL),(136,12,23,4,21,1,0,'Compound',NULL,NULL,1,NULL,0,9,'','2007-03-21 11:35:17','','2007-03-21 11:47:15',NULL,'',5,NULL,29,18),(140,12,1,6,21,2,0,'Forbehandling ICV',NULL,NULL,NULL,NULL,0,9,'','2007-03-21 11:36:22','','2007-03-21 11:47:15',NULL,'00749 0,8ug',1,1,30,NULL),(143,12,15,6,22,7,0,'Gender',NULL,NULL,46,NULL,0,8,'','2007-03-21 11:39:27','','2007-03-21 11:46:59',NULL,'',5,NULL,38,NULL),(144,12,10,6,22,8,0,'Dose',NULL,NULL,NULL,NULL,0,8,'','2007-03-21 11:39:34','','2007-03-21 11:46:59',NULL,'',2,4,39,NULL),(145,12,9,2,22,9,0,'mean Plasma Conc',NULL,NULL,NULL,NULL,0,8,'','2007-03-21 11:39:58','','2007-03-21 11:46:59',NULL,'',2,4,41,NULL),(146,12,9,2,22,10,1,'sd Plasma Conc',NULL,NULL,NULL,NULL,0,8,'','2007-03-21 11:40:02','','2007-03-21 11:46:59',NULL,'',2,4,41,NULL),(147,12,9,2,22,11,0,'mean Brain Conc',NULL,NULL,NULL,NULL,0,8,'','2007-03-21 11:41:50','','2007-03-21 11:46:59',NULL,'',2,4,42,NULL),(148,12,9,2,22,12,1,'sd Brain Conc',NULL,NULL,NULL,NULL,0,8,'','2007-03-21 11:41:54','','2007-03-21 11:46:59',NULL,'',2,4,42,NULL),(149,12,5,3,23,13,1,'Animal No.',NULL,NULL,NULL,NULL,0,8,'','2007-03-21 11:42:13','','2007-03-21 11:46:59',NULL,'',2,8,26,NULL),(150,12,7,6,23,14,0,'TimeAfterDosing',NULL,NULL,NULL,NULL,0,8,'','2007-03-21 11:42:27','','2007-03-21 11:46:59',NULL,'',2,4,40,NULL),(151,12,9,2,23,15,2,'Plasma Conc',NULL,NULL,NULL,NULL,0,8,'','2007-03-21 11:42:40','','2007-03-21 11:46:59',NULL,'',2,4,41,NULL),(152,12,9,2,23,16,2,'Brain Conc',NULL,NULL,NULL,NULL,0,8,'','2007-03-21 11:42:44','','2007-03-21 11:46:59',NULL,'',2,4,42,NULL),(153,12,7,2,23,17,0,'B/P',NULL,NULL,NULL,NULL,0,8,'','2007-03-21 11:42:47','','2007-03-21 11:46:59',NULL,'',2,4,43,NULL),(154,12,7,2,21,3,1,'mean B/P',NULL,NULL,NULL,NULL,0,6,'','2007-03-21 11:43:13','','2007-03-21 11:47:15',NULL,'',2,4,43,NULL),(155,12,7,2,21,4,2,'sd B/P',NULL,NULL,NULL,NULL,0,6,'','2007-03-21 11:43:16','','2007-03-21 11:47:15',NULL,'',2,4,43,NULL),(156,12,5,3,21,5,2,'Group No.',NULL,NULL,NULL,NULL,0,5,'','2007-03-21 11:44:30','','2007-03-21 11:47:15',NULL,'',2,8,26,NULL),(157,12,13,2,21,6,0,'Ass Doc.',NULL,NULL,NULL,NULL,0,4,'','2007-03-21 11:46:59','','2007-03-21 11:47:15',NULL,'',6,24,36,NULL),(158,5,23,4,9,2,0,'Compound',NULL,NULL,1,NULL,0,3,'','2007-03-21 14:32:21','','2007-03-21 14:32:21','N',NULL,5,NULL,15,15),(159,5,19,3,9,3,0,'Treatment Role',NULL,NULL,76,NULL,0,3,'','2007-03-21 14:32:32','','2007-03-21 14:32:32','N',NULL,5,NULL,6,NULL);
/*!40000 ALTER TABLE `parameters` ENABLE KEYS */;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `permissions`
--


/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (1,'Administer site'),(2,'Public pages - edit'),(3,'Public pages - view'),(4,'Public actions - execute'),(5,'Members only page -- view');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;

--
-- Table structure for table `plate_formats`
--

DROP TABLE IF EXISTS `plate_formats`;
CREATE TABLE `plate_formats` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `rows` int(11) default NULL,
  `columns` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `plate_formats`
--


/*!40000 ALTER TABLE `plate_formats` DISABLE KEYS */;
INSERT INTO `plate_formats` VALUES (1,'12 Vial Rack','A rack to hold 12 test tubes',1,12,0,'','2007-01-10 10:37:19','','2007-01-10 10:37:19');
/*!40000 ALTER TABLE `plate_formats` ENABLE KEYS */;

--
-- Table structure for table `plate_wells`
--

DROP TABLE IF EXISTS `plate_wells`;
CREATE TABLE `plate_wells` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `label` varchar(255) default NULL,
  `row_no` int(11) NOT NULL default '0',
  `column_no` int(11) NOT NULL default '0',
  `slot_no` int(11) NOT NULL default '0',
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `plate_wells`
--


/*!40000 ALTER TABLE `plate_wells` DISABLE KEYS */;
/*!40000 ALTER TABLE `plate_wells` ENABLE KEYS */;

--
-- Table structure for table `plates`
--

DROP TABLE IF EXISTS `plates`;
CREATE TABLE `plates` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` text,
  `external_ref` varchar(255) default NULL,
  `quantity_unit` varchar(255) default NULL,
  `quantity_value` float default NULL,
  `url` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default 'sys',
  `created_at` datetime NOT NULL default '0000-00-00 00:00:00',
  `updated_by` varchar(32) NOT NULL default 'sys',
  `updated_at` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `plates`
--


/*!40000 ALTER TABLE `plates` DISABLE KEYS */;
/*!40000 ALTER TABLE `plates` ENABLE KEYS */;

--
-- Table structure for table `plugin_schema_info`
--

DROP TABLE IF EXISTS `plugin_schema_info`;
CREATE TABLE `plugin_schema_info` (
  `plugin_name` varchar(255) default NULL,
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `plugin_schema_info`
--


/*!40000 ALTER TABLE `plugin_schema_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `plugin_schema_info` ENABLE KEYS */;

--
-- Table structure for table `process_definitions`
--

DROP TABLE IF EXISTS `process_definitions`;
CREATE TABLE `process_definitions` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(30) NOT NULL,
  `release` varchar(5) NOT NULL,
  `description` text,
  `protocol_catagory` varchar(20) default NULL,
  `protocol_status` varchar(20) default NULL,
  `literature_ref` varchar(255) default NULL,
  `access_control_id` int(11) NOT NULL default '0',
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `process_definitions_name_index` (`name`),
  KEY `process_definitions_updated_by_index` (`updated_by`),
  KEY `process_definitions_updated_at_index` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `process_definitions`
--


/*!40000 ALTER TABLE `process_definitions` DISABLE KEYS */;
/*!40000 ALTER TABLE `process_definitions` ENABLE KEYS */;

--
-- Table structure for table `process_instances`
--

DROP TABLE IF EXISTS `process_instances`;
CREATE TABLE `process_instances` (
  `id` int(11) NOT NULL auto_increment,
  `process_definition_id` int(11) NOT NULL,
  `name` varchar(77) default NULL,
  `version` int(6) NOT NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) default NULL,
  `created_at` time default NULL,
  `updated_by` varchar(32) default NULL,
  `updated_at` time default NULL,
  `how_to` text,
  PRIMARY KEY  (`id`),
  KEY `process_instances_name_index` (`name`),
  KEY `process_instances_process_definition_id_index` (`process_definition_id`),
  KEY `process_instances_updated_by_index` (`updated_by`),
  KEY `process_instances_updated_at_index` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `process_instances`
--


/*!40000 ALTER TABLE `process_instances` DISABLE KEYS */;
/*!40000 ALTER TABLE `process_instances` ENABLE KEYS */;

--
-- Temporary table structure for view `process_statistics`
--

DROP TABLE IF EXISTS `process_statistics`;
/*!50001 DROP VIEW IF EXISTS `process_statistics`*/;
/*!50001 CREATE TABLE `process_statistics` (
  `id` int(11),
  `study_parameter_id` int(11),
  `protocol_version_id` int(11),
  `parameter_id` int(11),
  `parameter_role_id` int(11),
  `parameter_type_id` int(11),
  `avg_values` double,
  `stddev_values` double,
  `num_values` bigint(20),
  `num_unique` bigint(20),
  `max_values` double,
  `min_values` double
) */;

--
-- Table structure for table `protocol_versions`
--

DROP TABLE IF EXISTS `protocol_versions`;
CREATE TABLE `protocol_versions` (
  `id` int(11) NOT NULL auto_increment,
  `study_protocol_id` int(11) default NULL,
  `name` varchar(77) default NULL,
  `version` int(6) NOT NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) default NULL,
  `created_at` time default NULL,
  `updated_by` varchar(32) default NULL,
  `updated_at` time default NULL,
  `how_to` text,
  PRIMARY KEY  (`id`),
  KEY `process_instances_name_index` (`name`),
  KEY `process_instances_process_definition_id_index` (`study_protocol_id`),
  KEY `process_instances_updated_by_index` (`updated_by`),
  KEY `process_instances_updated_at_index` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `protocol_versions`
--


/*!40000 ALTER TABLE `protocol_versions` DISABLE KEYS */;
INSERT INTO `protocol_versions` VALUES (1,1,'Materials:1',1,2,NULL,'19:50:48',NULL,'14:27:23',NULL),(2,2,'Animals:1',1,1,NULL,'20:05:26',NULL,'20:05:26',NULL),(3,3,'Treatments:1',1,1,NULL,'20:09:03',NULL,'20:09:03',NULL),(4,4,'Weights:1',1,2,NULL,'20:54:27',NULL,'20:55:11',NULL),(5,5,'Weight Summary:1',1,1,NULL,'21:00:33',NULL,'21:00:33',NULL),(6,6,'Taqman:1',1,3,NULL,'21:15:22',NULL,'21:20:28',NULL),(7,7,'Taqman Analysis:1',1,1,NULL,'21:22:37',NULL,'21:22:37',NULL),(8,8,'Histological Scoring:1',1,1,NULL,'21:31:18',NULL,'21:31:18',NULL),(9,9,'Setup Materials and Groups:1',1,1,NULL,'09:51:33',NULL,'09:51:33',NULL),(10,10,'Capture Raw Data:1',1,1,NULL,'10:07:13',NULL,'10:07:13',NULL),(11,11,'ED50 Calculation:1',1,1,NULL,'10:32:26',NULL,'10:32:26',NULL),(12,12,'Brain Plasma Assessment:1',1,1,NULL,'11:21:53',NULL,'11:21:54',NULL);
/*!40000 ALTER TABLE `protocol_versions` ENABLE KEYS */;

--
-- Table structure for table `queue_items`
--

DROP TABLE IF EXISTS `queue_items`;
CREATE TABLE `queue_items` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `comments` text,
  `study_queue_id` int(11) default NULL,
  `experiment_id` int(11) default NULL,
  `task_id` int(11) default NULL,
  `study_parameter_id` int(11) default NULL,
  `data_type` varchar(255) default NULL,
  `data_id` int(11) default NULL,
  `data_name` varchar(255) default NULL,
  `requested_by` varchar(60) default NULL,
  `assigned_to` varchar(60) default NULL,
  `requested_for` datetime default NULL,
  `accepted_at` datetime default NULL,
  `completed_at` datetime default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `request_service_id` int(11) default NULL,
  `status_id` int(11) default NULL,
  `priority_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `queue_items`
--


/*!40000 ALTER TABLE `queue_items` DISABLE KEYS */;
INSERT INTO `queue_items` VALUES (1,'req/1','OK',1,NULL,95,NULL,NULL,NULL,'AB0061','alemon','rshell','2007-01-16 00:00:00',NULL,'2007-02-09 00:00:00',2,'','2007-01-09 09:37:32','','2007-01-09 12:44:59',NULL,NULL,NULL),(2,'req/2','',1,NULL,95,NULL,NULL,NULL,'AB0064','alemon','thawkins','2007-01-16 00:00:00',NULL,'2007-01-16 00:00:00',1,'','2007-01-09 09:37:46','','2007-01-09 10:03:36',NULL,NULL,NULL),(3,'rea/3','Cannot do this assay in 1 day!',2,NULL,123,NULL,NULL,NULL,'AB00111','alemon','alemon','2007-01-10 00:00:00',NULL,'2007-01-09 00:00:00',1,'','2007-01-09 09:38:52','','2007-01-09 10:02:39',NULL,NULL,NULL),(4,'r/4','v.v.\\important',2,NULL,123,NULL,NULL,NULL,'AB00111','alemon','agibson','2007-01-15 00:00:00',NULL,'2007-02-09 00:00:00',1,'','2007-01-09 09:39:54','','2007-01-09 10:04:11',NULL,NULL,NULL),(5,'r/5','',2,NULL,125,NULL,NULL,NULL,'AB009','thawkins','alemon','2007-01-09 00:00:00',NULL,'2007-01-16 00:00:00',1,'','2007-01-09 10:28:00','','2007-01-09 10:30:39',NULL,NULL,NULL),(6,'r/6','Finished',2,NULL,129,NULL,NULL,NULL,'AB009','thawkins','','2007-01-09 00:00:00',NULL,'2007-02-09 00:00:00',1,'','2007-01-09 10:28:03','','2007-01-09 13:41:39',NULL,NULL,NULL),(7,'r6','',1,NULL,NULL,NULL,NULL,NULL,'AB0063','thawkins',NULL,'2007-01-10 00:00:00',NULL,NULL,0,'','2007-01-09 10:28:56','','2007-01-09 10:28:56',NULL,NULL,NULL),(8,'r8','',4,NULL,NULL,NULL,NULL,NULL,'AB0060','thawkins',NULL,'2007-01-15 00:00:00',NULL,NULL,0,'','2007-01-09 13:39:00','','2007-01-09 13:39:00',NULL,NULL,NULL),(9,'r8','',4,NULL,NULL,NULL,NULL,NULL,'AB00121','thawkins',NULL,'2007-01-15 00:00:00',NULL,NULL,0,'','2007-01-09 13:39:19','','2007-01-09 13:39:19',NULL,NULL,NULL),(10,'AB001','From RS-4-15',15,NULL,NULL,15,'Compound',1,'AB001','thawkins','4','2007-03-28 00:00:00','2007-03-21 13:31:49',NULL,3,'','2007-03-21 13:30:23','','2007-03-21 13:32:00',9,1,2),(11,'AB002','From RS-4-15',15,NULL,NULL,15,'Compound',2,'AB002','thawkins','4','2007-03-28 00:00:00','2007-03-21 13:31:52',NULL,3,'','2007-03-21 13:30:23','','2007-03-21 13:32:01',9,1,1),(12,'AB003','From RS-4-15',15,NULL,NULL,15,'Compound',3,'AB003','thawkins','4','2007-03-28 00:00:00','2007-03-21 13:31:56',NULL,3,'','2007-03-21 13:30:23','','2007-03-21 13:32:03',9,1,1),(13,'AB001','From RS-4-18',18,NULL,NULL,29,'Compound',1,'AB001','thawkins','4','2007-03-28 00:00:00',NULL,NULL,1,'','2007-03-21 13:30:24','','2007-03-21 13:30:24',10,0,NULL),(14,'AB002','From RS-4-18',18,NULL,NULL,29,'Compound',2,'AB002','thawkins','4','2007-03-28 00:00:00',NULL,NULL,1,'','2007-03-21 13:30:24','','2007-03-21 13:30:24',10,0,NULL),(15,'AB003','From RS-4-18',18,NULL,NULL,29,'Compound',3,'AB003','thawkins','4','2007-03-28 00:00:00',NULL,NULL,1,'','2007-03-21 13:30:24','','2007-03-21 13:30:24',10,0,NULL);
/*!40000 ALTER TABLE `queue_items` ENABLE KEYS */;

--
-- Table structure for table `report_columns`
--

DROP TABLE IF EXISTS `report_columns`;
CREATE TABLE `report_columns` (
  `id` int(11) NOT NULL auto_increment,
  `report_id` int(11) NOT NULL,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `join_model` varchar(255) default NULL,
  `label` varchar(255) default NULL,
  `action` text,
  `filter_operation` varchar(255) default NULL,
  `filter_text` varchar(255) default NULL,
  `subject_type` varchar(255) default NULL,
  `subject_id` int(11) default NULL,
  `data_element` int(11) default NULL,
  `is_visible` tinyint(1) default '1',
  `is_filterible` tinyint(1) default '1',
  `is_sortable` tinyint(1) default '1',
  `order_num` int(11) default NULL,
  `sort_num` int(11) default NULL,
  `sort_direction` varchar(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `report_columns`
--


/*!40000 ALTER TABLE `report_columns` DISABLE KEYS */;
INSERT INTO `report_columns` VALUES (23,12,'name',NULL,NULL,'Name',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,0,4,'',14,'','2007-01-16 17:57:31','','2007-01-18 22:36:17'),(24,12,'description',NULL,NULL,'Description',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,1,NULL,'',14,'','2007-01-16 17:57:31','','2007-01-18 22:36:17'),(25,12,'study.name',NULL,'study','Study Name',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,2,3,'',14,'','2007-01-16 18:53:12','','2007-01-18 22:36:17'),(26,12,'process.name',NULL,'process','Process Name',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,3,2,'',14,'','2007-01-16 18:56:13','','2007-01-18 22:36:17'),(27,12,'process.version',NULL,'process','Process Version',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,4,NULL,'',14,'','2007-01-16 18:56:31','','2007-01-18 22:36:17'),(29,13,'name',NULL,NULL,'Name',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,2,NULL,'',2,'','2007-01-16 23:17:06','','2007-01-16 23:51:37'),(30,13,'description',NULL,NULL,'Description',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,1,NULL,'',2,'','2007-01-16 23:17:06','','2007-01-16 23:51:37'),(31,13,'research_area',NULL,NULL,'Research_area',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,0,NULL,'',2,'','2007-01-16 23:17:06','','2007-01-16 23:51:37'),(32,13,'purpose',NULL,NULL,'Purpose',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,3,NULL,'',2,'','2007-01-16 23:17:06','','2007-01-16 23:51:37'),(33,13,'queues.name',NULL,'queues','Queues Name',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,4,NULL,'',3,'','2007-01-16 23:33:07','','2007-01-16 23:51:37'),(36,13,'experiments.name',NULL,'experiments','Experiments Name',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,5,NULL,'',2,'','2007-01-16 23:48:26','','2007-01-16 23:51:37'),(38,13,'experiments.process.name',NULL,'experiments','Process Name',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,7,NULL,'',2,'','2007-01-16 23:48:44','','2007-01-16 23:51:37'),(39,14,'name',NULL,NULL,'Name',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,0,NULL,NULL,0,'','2007-01-16 23:52:33','','2007-01-16 23:52:33'),(40,14,'description',NULL,NULL,'Description',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,1,NULL,NULL,0,'','2007-01-16 23:52:33','','2007-01-16 23:52:33'),(41,15,'avg_values',NULL,NULL,'Avg',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,0,NULL,'',1,'','2007-01-16 23:52:53','','2007-01-16 23:53:37'),(42,15,'stddev_values',NULL,NULL,'Std.Dev',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,1,NULL,'',1,'','2007-01-16 23:52:53','','2007-01-16 23:53:37'),(43,15,'num_values',NULL,NULL,'Count',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,2,NULL,'',1,'','2007-01-16 23:52:53','','2007-01-16 23:53:37'),(44,15,'num_unique',NULL,NULL,'unique',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,3,NULL,'',1,'','2007-01-16 23:52:53','','2007-01-16 23:53:37'),(45,15,'max_values',NULL,NULL,'Max',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,4,NULL,'',1,'','2007-01-16 23:52:53','','2007-01-16 23:53:37'),(46,15,'min_values',NULL,NULL,'Min',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,5,NULL,'',1,'','2007-01-16 23:52:53','','2007-01-16 23:53:37'),(47,15,'study.name',NULL,'study','Study Name',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,6,NULL,NULL,2,'','2007-01-16 23:53:25','','2007-01-16 23:53:33'),(48,16,'name',NULL,NULL,'Name',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,0,NULL,'',7,'','2007-01-16 23:54:57','','2007-01-17 00:10:03'),(49,16,'version',NULL,NULL,'Version',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,1,NULL,'',7,'','2007-01-16 23:54:57','','2007-01-17 00:10:03'),(50,16,'lock_version',NULL,NULL,'Lock_version',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,2,NULL,'',7,'','2007-01-16 23:54:57','','2007-01-17 00:10:03'),(51,16,'created_by',NULL,NULL,'Created_by',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,3,NULL,'',7,'','2007-01-16 23:54:57','','2007-01-17 00:10:03'),(52,16,'created_at',NULL,NULL,'Created_at',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,4,NULL,'',7,'','2007-01-16 23:54:57','','2007-01-17 00:10:03'),(53,16,'updated_by',NULL,NULL,'Updated_by',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,5,NULL,'',7,'','2007-01-16 23:54:57','','2007-01-17 00:10:03'),(54,16,'updated_at',NULL,NULL,'Updated_at',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,6,NULL,'',7,'','2007-01-16 23:54:57','','2007-01-17 00:10:03'),(55,16,'how_to',NULL,NULL,'How_to',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,7,NULL,'',8,'','2007-01-16 23:54:58','','2007-01-18 17:28:16'),(56,17,'name',NULL,NULL,'Name',NULL,'like','T%',NULL,NULL,NULL,1,1,1,0,3,'',2,'','2007-01-17 10:30:40','','2007-01-17 10:33:42'),(57,17,'description',NULL,NULL,'Description',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,0,2,'',2,'','2007-01-17 10:30:40','','2007-01-17 10:33:42'),(58,17,'process.name',NULL,'process','Process Name',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,0,1,'',3,'','2007-01-17 10:30:57','','2007-01-17 10:33:42'),(59,17,'protocol.definition.name',NULL,'protocol','Protocol Definition Name',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,0,NULL,'',3,'','2007-01-17 10:32:32','','2007-01-17 10:33:42'),(60,17,'protocol.definition.description',NULL,'protocol','Protocol Definition Description',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,0,NULL,'',3,'','2007-01-17 10:32:51','','2007-01-17 10:33:42'),(61,18,'data_value',NULL,NULL,'Data_value',NULL,'>','500',NULL,NULL,NULL,1,1,1,4,1,'desc',7,'','2007-01-17 10:38:42','','2007-01-18 20:11:37'),(62,18,'data_unit',NULL,NULL,'Data_unit',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,5,NULL,'',9,'','2007-01-17 10:38:42','','2007-01-18 21:01:47'),(63,18,'lock_version',NULL,NULL,'Lock_version',NULL,NULL,NULL,NULL,NULL,NULL,0,1,1,6,NULL,'',7,'','2007-01-17 10:38:42','','2007-01-18 20:11:37'),(64,18,'created_by',NULL,NULL,'Created_by',NULL,NULL,NULL,NULL,NULL,NULL,0,1,1,0,NULL,'',7,'','2007-01-17 10:38:42','','2007-01-18 20:11:37'),(65,18,'created_at',NULL,NULL,'Created_at',NULL,NULL,NULL,NULL,NULL,NULL,0,1,1,0,NULL,'',7,'','2007-01-17 10:38:42','','2007-01-18 20:11:37'),(66,18,'updated_by',NULL,NULL,'Updated_by',NULL,NULL,NULL,NULL,NULL,NULL,0,1,1,0,NULL,'',7,'','2007-01-17 10:38:42','','2007-01-18 20:11:37'),(67,18,'updated_at',NULL,NULL,'Updated_at',NULL,NULL,NULL,NULL,NULL,NULL,0,1,1,0,NULL,'',7,'','2007-01-17 10:38:42','','2007-01-18 20:11:37'),(68,18,'parameter.name',NULL,'parameter','Parameter Name',NULL,'=','Activity',NULL,NULL,NULL,1,1,1,3,NULL,'',8,'','2007-01-17 10:38:54','','2007-01-18 20:11:37'),(69,18,'task.name',NULL,'task','Task Name',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,2,NULL,'',8,'','2007-01-17 10:40:39','','2007-01-18 20:11:37'),(70,18,'task.experiment.study.name',NULL,'task','Study Name',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,1,NULL,'',8,'','2007-01-17 10:41:00','','2007-01-18 20:11:37'),(71,19,'name',NULL,NULL,'Name',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,0,NULL,NULL,0,'','2007-01-17 12:57:20','','2007-01-17 12:57:20'),(72,19,'description',NULL,NULL,'Description',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,0,NULL,NULL,0,'','2007-01-17 12:57:20','','2007-01-17 12:57:20'),(73,19,'assigned_to',NULL,NULL,'Assigned_to',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,0,NULL,NULL,0,'','2007-01-17 12:57:20','','2007-01-17 12:57:20'),(74,19,'status',NULL,NULL,'Status',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,0,NULL,NULL,0,'','2007-01-17 12:57:20','','2007-01-17 12:57:20'),(75,19,'priority',NULL,NULL,'Priority',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,0,NULL,NULL,0,'','2007-01-17 12:57:20','','2007-01-17 12:57:20'),(76,19,'study.name',NULL,'study','Study Name',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,6,NULL,NULL,1,'','2007-01-18 16:17:04','','2007-01-18 16:17:04'),(77,18,'parameter.context.label',NULL,'parameter','Label',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,11,NULL,'',2,'','2007-01-18 20:08:58','','2007-01-18 20:11:37'),(78,18,'parameter.context.level_no',NULL,'parameter','Level_no',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,12,NULL,'',2,'','2007-01-18 20:10:18','','2007-01-18 20:11:37'),(79,18,'parameter.context.process.name',NULL,'parameter','Process Name',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,13,NULL,'',2,'','2007-01-18 20:10:37','','2007-01-18 20:11:37'),(80,18,'parameter.context.process.process_definition.name',NULL,'parameter','Definition Name',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,14,NULL,'',2,'','2007-01-18 20:10:56','','2007-01-18 20:11:37'),(81,18,'parameter.context.process.process_definition.literature_ref',NULL,'parameter','Literature_ref',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,15,NULL,'',2,'','2007-01-18 20:11:03','','2007-01-18 20:11:37'),(85,12,'tasks.name',NULL,'tasks','Tasks Name',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,6,NULL,NULL,8,'','2007-01-18 21:58:47','','2007-01-18 22:36:17'),(86,12,'tasks.description',NULL,'tasks','Tasks Description',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,7,NULL,NULL,8,'','2007-01-18 21:58:59','','2007-01-18 22:36:17'),(91,12,'protocol.stage.name',NULL,'protocol','Protocol Stage Name',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,8,NULL,NULL,1,'','2007-01-18 23:30:24','','2007-01-18 23:30:24'),(92,12,'stats.type.name',NULL,'stats','Stats Type Name',NULL,NULL,NULL,NULL,NULL,NULL,1,0,0,9,NULL,NULL,1,'','2007-01-18 23:31:01','','2007-01-18 23:31:01'),(93,12,'stats.role.name',NULL,'stats','Stats Role Name',NULL,NULL,NULL,NULL,NULL,NULL,1,0,0,10,NULL,NULL,1,'','2007-01-18 23:31:14','','2007-01-18 23:31:14'),(94,12,'stats.avg_values',NULL,'stats','Stats Avg_values',NULL,NULL,NULL,NULL,NULL,NULL,1,0,0,11,NULL,NULL,1,'','2007-01-18 23:31:22','','2007-01-18 23:31:22'),(95,12,'stats.num_unique',NULL,'stats','Stats Num_unique',NULL,NULL,NULL,NULL,NULL,NULL,1,0,0,12,NULL,NULL,1,'','2007-01-18 23:31:30','','2007-01-18 23:31:30'),(96,12,'stats.num_values',NULL,'stats','Stats Num_values',NULL,NULL,NULL,NULL,NULL,NULL,1,0,0,13,NULL,NULL,2,'','2007-01-18 23:31:35','','2007-01-18 23:31:41'),(97,20,'label',NULL,NULL,'Label',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,0,NULL,NULL,0,'','2007-01-19 10:13:08','','2007-01-19 10:13:08'),(98,20,'comments',NULL,NULL,'Comments',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,1,NULL,NULL,0,'','2007-01-19 10:13:08','','2007-01-19 10:13:08'),(99,20,'status',NULL,NULL,'Status',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,99,NULL,NULL,0,'','2007-01-19 10:13:08','','2007-01-19 10:13:08'),(100,20,'priority',NULL,NULL,'Priority',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,99,NULL,NULL,0,'','2007-01-19 10:13:08','','2007-01-19 10:13:08'),(101,20,'data_type',NULL,NULL,'Data_type',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,4,NULL,NULL,0,'','2007-01-19 10:13:08','','2007-01-19 10:13:08'),(102,20,'data_name',NULL,NULL,'Item',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,99,NULL,NULL,0,'','2007-01-19 10:13:08','','2007-01-19 10:13:08'),(103,20,'assigned_to',NULL,NULL,'Assigned_to',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,6,NULL,NULL,0,'','2007-01-19 10:13:08','','2007-01-19 10:13:08'),(104,20,'id',NULL,NULL,'Id',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,7,NULL,NULL,0,'','2007-01-19 10:13:09','','2007-01-19 10:13:09'),(105,20,'queue.study.name',NULL,'queue','Study',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,99,NULL,NULL,0,'','2007-01-19 10:13:09','','2007-01-19 10:13:09'),(106,20,'queue.name',NULL,'queue','Service',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,99,NULL,NULL,0,'','2007-01-19 10:13:09','','2007-01-19 10:13:09'),(107,20,'experiment.name',NULL,'experiment','Expt.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,99,NULL,NULL,0,'','2007-01-19 10:13:09','','2007-01-19 10:13:09'),(108,20,'task.name',NULL,'task','Task',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,99,NULL,NULL,0,'','2007-01-19 10:13:09','','2007-01-19 10:13:09'),(109,20,'accepted_at',NULL,NULL,'Accepted_at','--- !ruby/object:Proc {}\n\n',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,99,NULL,NULL,0,'','2007-01-19 10:13:09','','2007-01-19 10:13:09'),(110,20,'updated_at',NULL,NULL,'Updated_at','--- !ruby/object:Proc {}\n\n',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,99,NULL,NULL,0,'','2007-01-19 10:13:09','','2007-01-19 10:13:09'),(119,23,'name',NULL,NULL,'Name',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,0,NULL,NULL,0,'','2007-01-19 13:07:09','','2007-01-19 13:07:09'),(120,23,'description',NULL,NULL,'Description',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,1,NULL,NULL,0,'','2007-01-19 13:07:09','','2007-01-19 13:07:09'),(121,23,'base_model',NULL,NULL,'Base_model',NULL,'in','(\'QueueItem\',\'StudyQueue\')',NULL,NULL,NULL,1,0,1,2,NULL,NULL,0,'','2007-01-19 13:07:09','','2007-01-19 13:07:09'),(122,23,'custom_sql',NULL,NULL,'Custom_sql',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,3,NULL,NULL,0,'','2007-01-19 13:07:09','','2007-01-19 13:07:09'),(124,24,'comments',NULL,NULL,'Comments',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,1,NULL,'',8,'','2007-01-19 14:46:08','','2007-02-08 14:31:21'),(125,24,'status',NULL,NULL,'Status',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,99,NULL,'',8,'','2007-01-19 14:46:08','','2007-02-08 14:31:21'),(126,24,'priority',NULL,NULL,'Priority',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,99,NULL,'',8,'','2007-01-19 14:46:08','','2007-02-08 14:31:21'),(128,24,'data_name',NULL,NULL,'Item',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,99,NULL,'',8,'','2007-01-19 14:46:08','','2007-02-08 14:31:21'),(129,24,'assigned_to',NULL,NULL,'Assigned_to',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,6,NULL,'',8,'','2007-01-19 14:46:08','','2007-02-08 14:31:21'),(131,24,'queue.study.name',NULL,'queue','Study',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,99,NULL,'',8,'','2007-01-19 14:46:08','','2007-02-08 14:31:21'),(132,24,'queue.name',NULL,'queue','Service',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,99,NULL,'',8,'','2007-01-19 14:46:08','','2007-02-08 14:31:21'),(133,24,'experiment.name',NULL,'experiment','Expt.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,99,NULL,'',8,'','2007-01-19 14:46:08','','2007-02-08 14:31:21'),(134,24,'task.name',NULL,'task','Task',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,99,NULL,'',8,'','2007-01-19 14:46:08','','2007-02-08 14:31:21'),(137,25,'name',NULL,NULL,'Name',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,0,NULL,'',1,'','2007-01-19 15:01:12','','2007-01-30 15:39:54'),(138,25,'description',NULL,NULL,'Description',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,1,NULL,'',1,'','2007-01-19 15:01:12','','2007-01-30 15:39:54'),(139,25,'base_model',NULL,NULL,'Base_model',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,2,NULL,'',1,'','2007-01-19 15:01:12','','2007-01-30 15:39:54'),(140,25,'custom_sql',NULL,NULL,'Custom_sql',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,3,NULL,'',1,'','2007-01-19 15:01:12','','2007-01-30 15:39:54'),(141,25,'id',NULL,NULL,'Id',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,4,NULL,'',1,'','2007-01-19 15:01:12','','2007-01-30 15:39:54'),(142,26,'name',NULL,NULL,'Name',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,0,NULL,NULL,0,'','2007-01-19 15:05:30','','2007-01-19 15:05:30'),(143,26,'description',NULL,NULL,'Description',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,1,NULL,NULL,0,'','2007-01-19 15:05:30','','2007-01-19 15:05:30'),(144,26,'research_area',NULL,NULL,'Research_area',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,2,NULL,NULL,0,'','2007-01-19 15:05:30','','2007-01-19 15:05:30'),(145,26,'purpose',NULL,NULL,'Purpose',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,3,NULL,NULL,0,'','2007-01-19 15:05:30','','2007-01-19 15:05:30'),(146,26,'id',NULL,NULL,'Id',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,4,NULL,NULL,0,'','2007-01-19 15:05:30','','2007-01-19 15:05:30'),(147,26,'custom_sql',NULL,NULL,'Custom_sql',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,5,NULL,NULL,0,'','2007-01-19 15:05:30','','2007-01-19 15:05:30'),(148,27,'name',NULL,NULL,'Name',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,0,NULL,NULL,0,'','2007-01-19 15:25:08','','2007-01-19 15:25:08'),(149,27,'description',NULL,NULL,'Description',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,1,NULL,NULL,0,'','2007-01-19 15:25:08','','2007-01-19 15:25:08'),(150,27,'id',NULL,NULL,'Id',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,2,NULL,NULL,0,'','2007-01-19 15:25:08','','2007-01-19 15:25:08'),(151,28,'name',NULL,NULL,'Name',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,0,NULL,NULL,0,'','2007-01-28 19:06:57','','2007-01-28 19:06:57'),(152,28,'description',NULL,NULL,'Description',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,1,NULL,NULL,0,'','2007-01-28 19:06:57','','2007-01-28 19:06:57'),(153,28,'research_area',NULL,NULL,'Research_area',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,2,NULL,NULL,0,'','2007-01-28 19:06:57','','2007-01-28 19:06:57'),(154,28,'purpose',NULL,NULL,'Purpose',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,3,NULL,NULL,0,'','2007-01-28 19:06:57','','2007-01-28 19:06:57'),(155,28,'id',NULL,NULL,'Id',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,4,NULL,NULL,0,'','2007-01-28 19:06:57','','2007-01-28 19:06:57'),(156,28,'process.name',NULL,'process','version',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,5,NULL,NULL,0,'','2007-01-28 19:06:57','','2007-01-28 19:06:57'),(157,28,'process.protocol.name',NULL,'process','protocol',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,6,NULL,NULL,0,'','2007-01-28 19:06:57','','2007-01-28 19:06:57'),(158,28,'process.protocol.study.name',NULL,'process','study',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,7,NULL,NULL,0,'','2007-01-28 19:06:57','','2007-01-28 19:06:57'),(159,29,'column_no',NULL,NULL,'Column_no',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,0,NULL,NULL,0,'','2007-01-28 19:09:30','','2007-01-28 19:09:30'),(160,29,'sequence_num',NULL,NULL,'Sequence_num',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,1,NULL,NULL,0,'','2007-01-28 19:09:30','','2007-01-28 19:09:30'),(161,29,'name',NULL,NULL,'Name',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,2,NULL,NULL,0,'','2007-01-28 19:09:30','','2007-01-28 19:09:30'),(162,29,'description',NULL,NULL,'Description',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,3,NULL,NULL,0,'','2007-01-28 19:09:30','','2007-01-28 19:09:30'),(163,29,'display_unit',NULL,NULL,'Display_unit',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,4,NULL,NULL,0,'','2007-01-28 19:09:30','','2007-01-28 19:09:30'),(164,29,'qualifier_style',NULL,NULL,'Qualifier_style',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,5,NULL,NULL,0,'','2007-01-28 19:09:30','','2007-01-28 19:09:30'),(165,29,'lock_version',NULL,NULL,'Lock_version',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,6,NULL,NULL,0,'','2007-01-28 19:09:30','','2007-01-28 19:09:30'),(166,29,'created_by',NULL,NULL,'Created_by',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,7,NULL,NULL,0,'','2007-01-28 19:09:30','','2007-01-28 19:09:30'),(167,29,'created_at',NULL,NULL,'Created_at',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,8,NULL,NULL,0,'','2007-01-28 19:09:30','','2007-01-28 19:09:30'),(168,29,'updated_by',NULL,NULL,'Updated_by',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,9,NULL,NULL,0,'','2007-01-28 19:09:30','','2007-01-28 19:09:30'),(169,29,'updated_at',NULL,NULL,'Updated_at',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,10,NULL,NULL,0,'','2007-01-28 19:09:30','','2007-01-28 19:09:30'),(170,29,'mandatory',NULL,NULL,'Mandatory',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,11,NULL,NULL,0,'','2007-01-28 19:09:30','','2007-01-28 19:09:30'),(171,29,'default_value',NULL,NULL,'Default_value',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,12,NULL,NULL,0,'','2007-01-28 19:09:30','','2007-01-28 19:09:30'),(172,29,'id',NULL,NULL,'Id',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,13,NULL,NULL,0,'','2007-01-28 19:09:30','','2007-01-28 19:09:30'),(173,29,'process.name',NULL,'process','version',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,14,NULL,NULL,0,'','2007-01-28 19:09:30','','2007-01-28 19:09:30'),(174,29,'process.protocol.name',NULL,'process','protocol',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,15,NULL,NULL,0,'','2007-01-28 19:09:30','','2007-01-28 19:09:30'),(175,29,'process.protocol.study.name',NULL,'process','study',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,16,NULL,NULL,0,'','2007-01-28 19:09:30','','2007-01-28 19:09:30'),(176,29,'type.name',NULL,'type','Type Name',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,17,NULL,NULL,1,'','2007-01-28 19:15:22','','2007-01-28 19:15:22'),(177,29,'data_format.name',NULL,'data_format','Data_format Name',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,18,NULL,NULL,1,'','2007-01-28 19:15:28','','2007-01-28 19:15:28'),(178,29,'data_element.name',NULL,'data_element','Data_element Name',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,19,NULL,NULL,1,'','2007-01-28 19:15:47','','2007-01-28 19:15:47'),(179,29,'data_type.name',NULL,'data_type','Data_type Name',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,20,NULL,NULL,1,'','2007-01-28 19:15:57','','2007-01-28 19:15:57'),(182,30,'name',NULL,NULL,'Name',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,2,NULL,'',4,'','2007-01-28 19:16:35','','2007-01-28 19:21:32'),(183,30,'description',NULL,NULL,'Description',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,3,NULL,'',4,'','2007-01-28 19:16:35','','2007-01-28 19:21:32'),(192,30,'default_value',NULL,NULL,'Default',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,12,NULL,'',4,'','2007-01-28 19:16:35','','2007-01-28 19:21:32'),(194,30,'process.protocol.study.name',NULL,'process','study',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,14,NULL,'',4,'','2007-01-28 19:16:35','','2007-01-28 19:21:32'),(195,30,'process.protocol.name',NULL,'process','protocol',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,15,NULL,'',4,'','2007-01-28 19:16:35','','2007-01-28 19:21:32'),(196,30,'process.name',NULL,'process','version',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,16,NULL,'',4,'','2007-01-28 19:16:35','','2007-01-28 19:21:32'),(197,30,'data_type.name',NULL,'data_type','data',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,17,NULL,'',4,'','2007-01-28 19:16:35','','2007-01-28 19:21:32'),(198,30,'role.name',NULL,'role','role',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,18,NULL,'',4,'','2007-01-28 19:16:36','','2007-01-28 19:21:32'),(199,30,'type.name',NULL,'type','type',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,19,NULL,'',4,'','2007-01-28 19:16:36','','2007-01-28 19:21:32'),(200,30,'context.label',NULL,'context','Row Label',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,15,NULL,'',5,'','2007-01-28 19:18:27','','2007-01-28 19:21:32'),(214,31,'process.protocol.stage.name',NULL,'process','Stage',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,1,NULL,'',4,'','2007-01-28 19:34:33','','2007-01-28 19:40:40'),(215,31,'process.protocol.study.name',NULL,'process','Study',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,3,NULL,'',4,'','2007-01-28 19:34:35','','2007-01-28 19:40:39'),(216,31,'process.protocol.name',NULL,'process','Protocol ',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,4,NULL,'',4,'','2007-01-28 19:34:40','','2007-01-28 19:40:40'),(217,31,'process.version',NULL,'process','Version',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,5,NULL,'',4,'','2007-01-28 19:34:46','','2007-01-28 19:40:40'),(218,31,'process.protocol.study.research_area',NULL,'process','Research Area',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,2,NULL,'',4,'','2007-01-28 19:35:54','','2007-01-28 19:40:40'),(220,32,'avg_values',NULL,NULL,'Avg',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,10,NULL,'',3,'','2007-01-28 20:04:07','','2007-01-28 20:06:51'),(221,32,'stddev_values',NULL,NULL,'Std.dev.',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,11,NULL,'',3,'','2007-01-28 20:04:07','','2007-01-28 20:06:51'),(222,32,'num_values',NULL,NULL,'count',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,12,NULL,'',3,'','2007-01-28 20:04:07','','2007-01-28 20:06:51'),(223,32,'num_unique',NULL,NULL,'unique',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,13,NULL,'',3,'','2007-01-28 20:04:08','','2007-01-28 20:06:51'),(224,32,'max_values',NULL,NULL,'Max',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,14,NULL,'',3,'','2007-01-28 20:04:08','','2007-01-28 20:06:51'),(225,32,'min_values',NULL,NULL,'Min',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,15,NULL,'',3,'','2007-01-28 20:04:08','','2007-01-28 20:06:51'),(226,32,'parameter.name',NULL,'parameter','Parameter ',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,4,NULL,'',4,'','2007-01-28 20:04:25','','2007-01-28 20:06:51'),(228,32,'process.protocol.study.name',NULL,'process','Study',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,1,NULL,'',3,'','2007-01-28 20:05:29','','2007-01-28 20:06:51'),(229,32,'process.protocol.name',NULL,'process','Protocol ',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,2,NULL,'',3,'','2007-01-28 20:05:33','','2007-01-28 20:06:51'),(230,32,'process.version',NULL,'process','Version',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,3,NULL,'',3,'','2007-01-28 20:05:36','','2007-01-28 20:06:51'),(231,31,'id',NULL,NULL,'Id',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,5,NULL,NULL,0,'','2007-01-28 20:09:28','','2007-01-28 20:09:28'),(232,32,'parameter_id',NULL,NULL,'Parameter_id',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,10,NULL,NULL,0,'','2007-01-28 20:09:28','','2007-01-28 20:09:28'),(233,33,'avg_values',NULL,NULL,'Avg_values',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,10,NULL,'',1,'','2007-01-28 22:49:44','','2007-01-28 22:51:46'),(234,33,'stddev_values',NULL,NULL,'Stddev_values',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,11,NULL,'',1,'','2007-01-28 22:49:44','','2007-01-28 22:51:46'),(235,33,'num_values',NULL,NULL,'Num_values',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,12,NULL,'',1,'','2007-01-28 22:49:44','','2007-01-28 22:51:46'),(236,33,'num_unique',NULL,NULL,'Num_unique',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,13,NULL,'',1,'','2007-01-28 22:49:45','','2007-01-28 22:51:46'),(237,33,'max_values',NULL,NULL,'Max_values',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,14,NULL,'',1,'','2007-01-28 22:49:45','','2007-01-28 22:51:46'),(238,33,'min_values',NULL,NULL,'Min_values',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,15,NULL,'',1,'','2007-01-28 22:49:45','','2007-01-28 22:51:46'),(239,33,'task.name',NULL,'task','Task',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,4,NULL,'',2,'','2007-01-28 22:50:02','','2007-01-28 22:51:46'),(240,33,'task.status.name',NULL,'task','Status',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,5,NULL,'',2,'','2007-01-28 22:50:16','','2007-01-28 22:51:46'),(241,33,'task.protocol.name',NULL,'task','Protocol',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,2,NULL,'',2,'','2007-01-28 22:50:22','','2007-01-28 22:51:46'),(242,33,'task.experiment.name',NULL,'task','Experiment ',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,3,NULL,'',2,'','2007-01-28 22:50:28','','2007-01-28 22:51:46'),(243,33,'task.experiment.study.name',NULL,'task','Study',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,1,NULL,'',2,'','2007-01-28 22:50:33','','2007-01-28 22:51:46'),(244,33,'parameter_id',NULL,NULL,'Parameter_id',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,11,NULL,NULL,0,'','2007-01-28 23:12:13','','2007-01-28 23:12:13'),(245,31,'study_parameter_id',NULL,NULL,'Study_parameter_id',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,6,NULL,NULL,0,'','2007-01-28 23:34:14','','2007-01-28 23:34:14'),(246,32,'study_parameter_id',NULL,NULL,'Study_parameter_id',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,11,NULL,NULL,0,'','2007-01-28 23:34:14','','2007-01-28 23:34:14'),(247,33,'study_parameter_id',NULL,NULL,'Study_parameter_id',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,12,NULL,NULL,0,'','2007-01-28 23:34:14','','2007-01-28 23:34:14'),(248,34,'avg_values',NULL,NULL,'Avg',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,10,NULL,'',4,'','2007-01-28 23:35:54','','2007-01-29 16:12:46'),(249,34,'stddev_values',NULL,NULL,'Stddev',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,11,NULL,'',4,'','2007-01-28 23:35:54','','2007-01-29 16:12:47'),(250,34,'num_values',NULL,NULL,'count',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,12,NULL,'',4,'','2007-01-28 23:35:54','','2007-01-29 16:12:46'),(251,34,'num_unique',NULL,NULL,'unique',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,13,NULL,'',4,'','2007-01-28 23:35:54','','2007-01-29 16:12:47'),(252,34,'max_values',NULL,NULL,'Max',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,14,NULL,'',4,'','2007-01-28 23:35:54','','2007-01-29 16:12:47'),(253,34,'min_values',NULL,NULL,'Min',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,15,NULL,'',4,'','2007-01-28 23:35:54','','2007-01-29 16:12:46'),(254,34,'id',NULL,NULL,'Id',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,99,NULL,'',4,'','2007-01-28 23:35:54','','2007-01-29 16:12:46'),(255,34,'study_parameter_id',NULL,NULL,'Study_parameter_id',NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,99,NULL,'',4,'','2007-01-28 23:35:54','','2007-01-29 16:12:47'),(256,34,'experiment.name',NULL,'experiment','Experiment',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,1,NULL,'',5,'','2007-01-29 10:29:37','','2007-01-29 16:12:47'),(257,34,'experiment.study.name',NULL,'experiment','Study',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,2,NULL,'',5,'','2007-01-29 10:29:43','','2007-01-29 16:12:46'),(258,35,'label',NULL,NULL,'Label',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,0,NULL,NULL,0,'','2007-01-29 14:18:34','','2007-01-29 14:18:34'),(259,35,'row_label',NULL,NULL,'Row_label',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,1,NULL,NULL,0,'','2007-01-29 14:18:34','','2007-01-29 14:18:34'),(260,35,'row_no',NULL,NULL,'Row_no',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,2,NULL,NULL,0,'','2007-01-29 14:18:34','','2007-01-29 14:18:34'),(261,35,'column_no',NULL,NULL,'Column_no',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,3,NULL,NULL,0,'','2007-01-29 14:18:34','','2007-01-29 14:18:34'),(262,35,'parameter_name',NULL,NULL,'Parameter_name',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,4,NULL,NULL,0,'','2007-01-29 14:18:34','','2007-01-29 14:18:34'),(263,35,'data_value',NULL,NULL,'Data_value',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,5,NULL,NULL,0,'','2007-01-29 14:18:34','','2007-01-29 14:18:34'),(264,35,'created_by',NULL,NULL,'Created_by',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,6,NULL,NULL,0,'','2007-01-29 14:18:34','','2007-01-29 14:18:34'),(265,35,'created_at',NULL,NULL,'Created_at',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,7,NULL,NULL,0,'','2007-01-29 14:18:34','','2007-01-29 14:18:34'),(266,35,'updated_by',NULL,NULL,'Updated_by',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,8,NULL,NULL,0,'','2007-01-29 14:18:34','','2007-01-29 14:18:34'),(267,35,'updated_at',NULL,NULL,'Updated_at',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,9,NULL,NULL,0,'','2007-01-29 14:18:34','','2007-01-29 14:18:34'),(268,35,'id',NULL,NULL,'Id',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,10,NULL,NULL,0,'','2007-01-29 14:18:34','','2007-01-29 14:18:34'),(269,35,'parameter_id',NULL,NULL,'Parameter_id',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,11,NULL,NULL,0,'','2007-01-29 14:18:34','','2007-01-29 14:18:34'),(270,35,'parameter_context_id',NULL,NULL,'Parameter_context_id',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,12,NULL,NULL,0,'','2007-01-29 14:18:34','','2007-01-29 14:18:34'),(271,37,'row_no',NULL,NULL,'Row_no',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,0,NULL,'',4,'','2007-01-29 16:30:43','','2007-01-29 19:52:26'),(272,37,'column_no',NULL,NULL,'Column_no',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,NULL,'',4,'','2007-01-29 16:30:43','','2007-01-29 19:52:26'),(273,37,'compound_name',NULL,NULL,'Compound_name',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,2,NULL,'',4,'','2007-01-29 16:30:43','','2007-01-29 19:52:26'),(274,37,'label',NULL,NULL,'Label',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,3,NULL,'',4,'','2007-01-29 16:30:43','','2007-01-29 19:52:26'),(275,37,'row_label',NULL,NULL,'Row_label',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,NULL,4,NULL,'',4,'','2007-01-29 16:30:43','','2007-01-29 19:52:26'),(276,37,'parameter_name',NULL,NULL,'Parameter',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,5,NULL,'',4,'','2007-01-29 16:30:43','','2007-01-29 19:52:26'),(277,37,'data_value',NULL,NULL,'Data_value',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,6,NULL,'',4,'','2007-01-29 16:30:43','','2007-01-29 19:52:26'),(278,37,'created_by',NULL,NULL,'Created_by',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,7,NULL,'',4,'','2007-01-29 16:30:44','','2007-01-29 19:52:26'),(279,37,'created_at',NULL,NULL,'Created_at',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8,NULL,'',4,'','2007-01-29 16:30:44','','2007-01-29 19:52:26'),(280,37,'updated_by',NULL,NULL,'Updated_by',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,9,NULL,'',4,'','2007-01-29 16:30:44','','2007-01-29 19:52:26'),(281,37,'updated_at',NULL,NULL,'Updated_at',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,10,NULL,'',4,'','2007-01-29 16:30:44','','2007-01-29 19:52:26'),(282,37,'usage.name',NULL,'usage','Usage Name',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,11,NULL,'',5,'','2007-01-29 16:33:37','','2007-01-29 19:52:26'),(283,37,'task.name',NULL,'task','Task',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,12,NULL,'',4,'','2007-01-29 16:44:27','','2007-01-29 19:52:26'),(284,37,'task.experiment.name',NULL,'task','Experiment',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,13,NULL,'',4,'','2007-01-29 16:44:35','','2007-01-29 19:52:26'),(286,37,'compound.mass',NULL,'compound','Mass',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,14,NULL,'',3,'','2007-01-29 17:59:11','','2007-01-29 19:52:26'),(288,37,'compound.formula',NULL,'compound','Compound Formula',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,15,NULL,'',2,'','2007-01-29 19:52:20','','2007-01-29 19:52:26'),(289,38,'row_no',NULL,NULL,'Row_no',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,0,NULL,'',1,'','2007-01-29 22:37:44','','2007-01-29 22:41:45'),(290,38,'column_no',NULL,NULL,'Column_no',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,1,NULL,'',1,'','2007-01-29 22:37:44','','2007-01-29 22:41:45'),(291,38,'compound_name',NULL,NULL,'Compound_name',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,2,NULL,'',1,'','2007-01-29 22:37:44','','2007-01-29 22:41:45'),(292,38,'label',NULL,NULL,'Label',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,3,NULL,'',1,'','2007-01-29 22:37:44','','2007-01-29 22:41:45'),(293,38,'row_label',NULL,NULL,'Row_label',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,4,NULL,'',1,'','2007-01-29 22:37:44','','2007-01-29 22:41:45'),(294,38,'parameter_name',NULL,NULL,'Parameter_name',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,5,NULL,'',1,'','2007-01-29 22:37:44','','2007-01-29 22:41:45'),(295,38,'data_value',NULL,NULL,'Data_value',NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,1,6,NULL,'',1,'','2007-01-29 22:37:44','','2007-01-29 22:41:45'),(296,38,'created_by',NULL,NULL,'Created_by',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,7,NULL,'',1,'','2007-01-29 22:37:44','','2007-01-29 22:41:45'),(297,38,'created_at',NULL,NULL,'Created_at',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,8,NULL,'',1,'','2007-01-29 22:37:44','','2007-01-29 22:41:45'),(298,38,'updated_by',NULL,NULL,'Updated_by',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,9,NULL,'',1,'','2007-01-29 22:37:44','','2007-01-29 22:41:45'),(299,38,'updated_at',NULL,NULL,'Updated_at',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,10,NULL,'',1,'','2007-01-29 22:37:44','','2007-01-29 22:41:45'),(300,39,'label',NULL,NULL,'Label',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,0,NULL,NULL,0,'','2007-02-03 16:12:38','','2007-02-03 16:12:38'),(301,39,'row_label',NULL,NULL,'Row_label',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,1,NULL,NULL,0,'','2007-02-03 16:12:38','','2007-02-03 16:12:38'),(302,39,'row_no',NULL,NULL,'Row_no',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,2,NULL,NULL,0,'','2007-02-03 16:12:38','','2007-02-03 16:12:38'),(303,39,'column_no',NULL,NULL,'Column_no',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,3,NULL,NULL,0,'','2007-02-03 16:12:38','','2007-02-03 16:12:38'),(304,39,'parameter_name',NULL,NULL,'Parameter_name',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,4,NULL,NULL,0,'','2007-02-03 16:12:38','','2007-02-03 16:12:38'),(305,39,'data_value',NULL,NULL,'Data_value',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,5,NULL,NULL,0,'','2007-02-03 16:12:38','','2007-02-03 16:12:38'),(306,39,'created_by',NULL,NULL,'Created_by',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,6,NULL,NULL,0,'','2007-02-03 16:12:38','','2007-02-03 16:12:38'),(307,39,'created_at',NULL,NULL,'Created_at',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,7,NULL,NULL,0,'','2007-02-03 16:12:38','','2007-02-03 16:12:38'),(308,39,'updated_by',NULL,NULL,'Updated_by',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,8,NULL,NULL,0,'','2007-02-03 16:12:38','','2007-02-03 16:12:38'),(309,39,'updated_at',NULL,NULL,'Updated_at',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,9,NULL,NULL,0,'','2007-02-03 16:12:38','','2007-02-03 16:12:38'),(310,39,'id',NULL,NULL,'Id',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,10,NULL,NULL,0,'','2007-02-03 16:12:38','','2007-02-03 16:12:38'),(311,39,'task.id',NULL,'task','Task Id',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,11,NULL,NULL,0,'','2007-02-03 16:12:38','','2007-02-03 16:12:38'),(312,39,'task.name',NULL,'task','Task Name',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,12,NULL,NULL,0,'','2007-02-03 16:12:38','','2007-02-03 16:12:38'),(313,24,'name',NULL,NULL,'Name',NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,0,NULL,'',7,'','2007-02-08 14:15:00','','2007-02-08 14:31:21'),(314,40,'name',NULL,NULL,'Name',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,0,NULL,NULL,0,'','2007-03-01 07:07:52','','2007-03-01 07:07:52'),(315,40,'description',NULL,NULL,'Description',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,1,NULL,NULL,0,'','2007-03-01 07:07:52','','2007-03-01 07:07:52'),(316,40,'requested_for',NULL,NULL,'Requested_for',NULL,NULL,NULL,NULL,NULL,NULL,1,0,1,2,NULL,NULL,0,'','2007-03-01 07:07:52','','2007-03-01 07:07:52'),(317,40,'id',NULL,NULL,'Id',NULL,NULL,NULL,NULL,NULL,NULL,0,0,1,3,NULL,NULL,0,'','2007-03-01 07:07:52','','2007-03-01 07:07:52');
/*!40000 ALTER TABLE `report_columns` ENABLE KEYS */;

--
-- Table structure for table `reports`
--

DROP TABLE IF EXISTS `reports`;
CREATE TABLE `reports` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `base_model` varchar(255) default NULL,
  `custom_sql` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `reports`
--


/*!40000 ALTER TABLE `reports` DISABLE KEYS */;
INSERT INTO `reports` VALUES (12,'Expt1','Test is a simple report on the experiment level','Experiment',NULL,21,'','2007-01-16 17:57:31','','2007-01-18 22:36:17'),(13,'All Studies','List of all studies','Study',NULL,2,'','2007-01-16 23:17:06','','2007-01-16 23:51:37'),(14,'All Experiments','','Experiment',NULL,0,'','2007-01-16 23:52:33','','2007-01-16 23:52:33'),(15,'Study Stats','','StudyStatistics',NULL,1,'','2007-01-16 23:52:53','','2007-01-16 23:53:37'),(16,'Protocol Versions','','ProcessInstance',NULL,7,'','2007-01-16 23:54:57','','2007-01-17 00:10:03'),(17,'My Experiments','Simple report of what I have done','Experiment',NULL,2,'','2007-01-17 10:30:40','','2007-01-17 10:33:42'),(18,'My Results','This is a simple report for extraction of Activity Values from a task','TaskValue',NULL,7,'','2007-01-17 10:38:42','','2007-01-18 20:11:36'),(19,'My Services','','StudyQueue',NULL,0,'','2007-01-17 12:57:20','','2007-01-17 12:57:20'),(20,'new QueueItem','new QueueItem report','QueueItem',NULL,0,'','2007-01-19 10:13:08','','2007-01-19 10:13:08'),(23,'new Report','new Report report','Report',NULL,0,'','2007-01-19 13:07:09','','2007-01-19 13:07:09'),(25,'ReportList','Default reports for display as /Report/list','Report',NULL,1,'','2007-01-19 15:01:12','','2007-01-30 15:39:54'),(26,'StudyList','Default reports for display as /Study/list','Study',NULL,0,'','2007-01-19 15:05:30','','2007-01-19 15:05:30'),(27,'DataContextList','Default reports for display as /DataContext/list','DataContext',NULL,0,'','2007-01-19 15:25:08','','2007-01-19 15:25:08'),(30,'ParameterList','Default reports for display as /Parameter/list','Parameter',NULL,4,'','2007-01-28 19:16:35','','2007-01-28 19:21:32'),(31,'ParameterProtocols','List of Parameter Protocols','Parameter',NULL,3,'','2007-01-28 19:33:22','','2007-01-28 19:40:39'),(32,'ParameterStatistics','Internal report on parameter statistics','ProcessStatistics',NULL,3,'','2007-01-28 20:04:07','','2007-01-28 20:06:51'),(33,'TaskStatistics','Standard Task Statistics Report','TaskStatistics',NULL,1,'','2007-01-28 22:49:44','','2007-01-28 22:51:46'),(34,'ExperimentStatistics','Default reports for display as /ExperimentStatistics/list','ExperimentStatistics',NULL,4,'','2007-01-28 23:35:54','','2007-01-29 16:12:46'),(35,'ParameterResults','Default reports for display as /TaskResult/list','TaskResult',NULL,0,'','2007-01-29 14:18:34','','2007-01-29 14:18:34'),(37,'Compound Results','test','CompoundResult',NULL,4,'','2007-01-29 16:30:43','','2007-01-29 19:52:26'),(38,'Results for Compound','Compound Results','CompoundResult',NULL,1,'','2007-01-29 22:37:44','','2007-01-29 22:41:44'),(39,'TaskResult2','Default reports for display as /TaskResult/list','TaskResult',NULL,0,'','2007-02-03 16:12:38','','2007-02-03 16:12:38'),(40,'RequestList','Default reports for display as /Request/list','Request',NULL,0,'','2007-03-01 07:07:52','','2007-03-01 07:07:52');
/*!40000 ALTER TABLE `reports` ENABLE KEYS */;

--
-- Table structure for table `request_lists`
--

DROP TABLE IF EXISTS `request_lists`;
CREATE TABLE `request_lists` (
  `id` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `request_lists`
--


/*!40000 ALTER TABLE `request_lists` DISABLE KEYS */;
/*!40000 ALTER TABLE `request_lists` ENABLE KEYS */;

--
-- Table structure for table `request_services`
--

DROP TABLE IF EXISTS `request_services`;
CREATE TABLE `request_services` (
  `id` int(11) NOT NULL auto_increment,
  `request_id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `requested_by` varchar(60) default NULL,
  `requested_for` datetime default NULL,
  `assigned_to` varchar(60) default NULL,
  `accepted_at` datetime default NULL,
  `completed_at` datetime default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `status_id` int(11) default NULL,
  `priority_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `request_services`
--


/*!40000 ALTER TABLE `request_services` DISABLE KEYS */;
INSERT INTO `request_services` VALUES (1,1,6,'RS-1-6',NULL,'rshell','2007-03-14 00:00:00',NULL,NULL,NULL,0,'','2007-03-04 05:56:19','','2007-03-04 05:56:19',NULL,NULL),(2,1,7,'RS-1-7',NULL,'rshell','2007-03-14 00:00:00',NULL,NULL,NULL,0,'','2007-03-04 05:56:23','','2007-03-04 05:56:23',NULL,NULL),(3,2,6,'RS-2-6',NULL,'rshell','2007-03-14 00:00:00',NULL,NULL,NULL,0,'','2007-03-04 05:58:51','','2007-03-04 05:58:51',NULL,NULL),(4,2,9,'RS-2-9',NULL,'rshell','2007-03-14 00:00:00',NULL,NULL,NULL,0,'','2007-03-04 05:58:52','','2007-03-04 05:58:52',NULL,NULL),(5,2,10,'RS-2-10',NULL,'rshell','2007-03-14 00:00:00',NULL,NULL,NULL,0,'','2007-03-04 05:58:54','','2007-03-04 05:58:54',NULL,NULL),(6,2,11,'RS-2-11',NULL,'rshell','2007-03-14 00:00:00',NULL,NULL,NULL,0,'','2007-03-04 05:58:56','','2007-03-04 05:58:56',NULL,NULL),(7,3,15,'RS-3-15',NULL,'thawkins','2007-04-21 00:00:00',NULL,NULL,NULL,0,'','2007-03-21 12:57:51','','2007-03-21 12:57:51',NULL,NULL),(8,3,18,'RS-3-18',NULL,'thawkins','2007-04-21 00:00:00',NULL,NULL,NULL,0,'','2007-03-21 13:04:35','','2007-03-21 13:04:35',NULL,NULL),(9,4,15,'RS-4-15',NULL,'thawkins','2007-03-28 00:00:00',NULL,NULL,NULL,0,'','2007-03-21 13:29:20','','2007-03-21 13:29:20',NULL,NULL),(10,4,18,'RS-4-18',NULL,'thawkins','2007-03-28 00:00:00',NULL,NULL,NULL,0,'','2007-03-21 13:30:00','','2007-03-21 13:30:00',NULL,NULL);
/*!40000 ALTER TABLE `request_services` ENABLE KEYS */;

--
-- Table structure for table `requests`
--

DROP TABLE IF EXISTS `requests`;
CREATE TABLE `requests` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `requested_by` varchar(255) default NULL,
  `requested_for` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `list_id` int(11) default NULL,
  `data_element_id` int(11) default NULL,
  `status_id` int(11) default NULL,
  `priority_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `requests`
--


/*!40000 ALTER TABLE `requests` DISABLE KEYS */;
INSERT INTO `requests` VALUES (3,'TH070321','Not urgent but need results by the end of April','thawkins','2007-04-21',8,'','2007-03-21 09:00:10','','2007-03-21 13:05:14',5,1,0,1),(4,'TH003','Generic training request','thawkins','2007-03-28',2,'','2007-03-21 13:29:07','','2007-03-21 13:30:23',6,1,0,NULL);
/*!40000 ALTER TABLE `requests` ENABLE KEYS */;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `parent_id` int(11) default NULL,
  `description` varchar(1024) NOT NULL,
  `default_page_id` int(11) default NULL,
  `cache` longtext,
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`),
  KEY `fk_role_parent_id` (`parent_id`),
  KEY `fk_role_default_page_id` (`default_page_id`),
  CONSTRAINT `fk_role_default_page_id` FOREIGN KEY (`default_page_id`) REFERENCES `content_pages` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_role_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `roles` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `roles`
--


/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Public',NULL,'Members of the public who are not logged in.',NULL,'--- \n:credentials: !ruby/object:Credentials \n  actions: \n    specimens: \n      list: false\n    containers: \n      list: false\n    experiments: \n      import_file: true\n      new: false\n      list: false\n      edit: false\n      timeline: false\n      show: false\n      reports: false\n    study_stages: \n      new: false\n      list: false\n      edit: false\n      destroy: false\n    studies: \n      new: false\n      list: false\n      parameters: false\n      edit: false\n      timeline: false\n      reports: false\n      protocols: false\n    parameter_roles: \n      new: false\n      list: false\n      edit: false\n      destroy: false\n    data_concepts: \n      list: false\n      edit: false\n      destroy: false\n      create: false\n      create_child: false\n      show: false\n      export: false\n      update: false\n    menu_items: \n      list: false\n      link: true\n    roles: \n      list: false\n    auth: \n      logout: true\n      login_failed: true\n      forgotten: true\n      login: true\n    catalogue: \n      new: false\n      add: false\n      list: false\n      edit: false\n      destroy: false\n      show: false\n      remove: false\n    site_controllers: \n      list: false\n    parameters: \n      list: false\n      show: false\n    study_parameters: \n      new: false\n      list: false\n      edit: false\n    data_systems: \n      new: false\n      list: false\n      edit: false\n      create: false\n      show: false\n      update: false\n    data_elements: \n      list: false\n      edit: false\n      destroy: false\n      create: false\n      create_child: false\n      show: false\n      export: false\n    study_queues: \n      new: false\n      list: false\n      edit: false\n      show: false\n    data_formats: \n      new: false\n      list: false\n      update: false\n    tasks: \n      new: false\n      list: false\n      sheet: false\n      edit: false\n      destroy: false\n      create: false\n      show: false\n      update: false\n    parameter_types: \n      new: false\n      list: false\n      edit: false\n      destroy: false\n    plates: \n      new: false\n      list: false\n      edit: false\n      destroy: false\n    data_contexts: \n      new: false\n      list: false\n      edit: false\n      destroy: false\n      create: false\n      show: false\n      export: false\n      update: false\n    requests: \n      new: false\n      list: false\n      edit: false\n      destroy: false\n    plate_formats: \n      list: false\n      show: false\n    batches: \n      list: false\n    compounds: \n      new: false\n      list: false\n      edit: false\n      destroy: false\n    data_types: \n      new: false\n      list: false\n      edit: false\n    users: \n      list: false\n    system_settings: \n      list: false\n    controller_actions: \n      list: false\n    permissions: \n      list: false\n    content_pages: \n      list: false\n      view_default: true\n      view: true\n    reports: \n      list: false\n      builder: false\n    samples: \n      list: false\n    study_protocols: \n      new: false\n      list: false\n      edit: false\n      destroy: false\n      create: false\n      update: false\n    finder: \n      query: false\n  controllers: \n    containers: false\n    specimens: false\n    experiments: false\n    study_stages: false\n    studies: false\n    parameter_roles: false\n    data_concepts: false\n    roles: false\n    menu_items: false\n    auth: false\n    catalogue: false\n    site_controllers: false\n    request_services: false\n    parameters: false\n    markup_styles: false\n    study_parameters: false\n    data_systems: false\n    treatment_groups: false\n    data_elements: false\n    data_capture: true\n    study_queues: false\n    roles_permissions: false\n    data_formats: false\n    tasks: false\n    parameter_types: false\n    plates: false\n    data_contexts: false\n    requests: false\n    plate_formats: false\n    batches: false\n    compounds: false\n    data_types: false\n    users: false\n    system_settings: false\n    permissions: false\n    controller_actions: false\n    content_pages: false\n    reports: false\n    samples: false\n    study_protocols: false\n    charts: false\n    finder: false\n  pages: \n    TBD: true\n    Catalogue: true\n    notfound: true\n    site_admin: false\n    Execution: true\n    Inventory: true\n    Analysis_Introduction: true\n    contact_us: true\n    Requesting: false\n    Organisation: false\n    credits: true\n    denied: true\n    expired: true\n    home: true\n    Study_Report: true\n  permission_ids: \n  - 4\n  - 3\n  role_id: 1\n  role_ids: \n  - 1\n  updated_at: 2007-03-08 05:08:32 +00:00\n:menu: !ruby/object:Menu \n  by_id: \n    49: &id006 !ruby/object:Menu::Node \n      content_page_id: 19\n      controller_action_id: \n      id: 49\n      label: Timeline\n      name: inv/time\n      parent: \n      parent_id: 16\n      site_controller_id: \n      url: /TBD\n    38: &id002 !ruby/object:Menu::Node \n      content_page_id: 19\n      controller_action_id: \n      id: 38\n      label: Notes\n      name: inv/notes\n      parent: \n      parent_id: 16\n      site_controller_id: \n      url: /TBD\n    16: &id007 !ruby/object:Menu::Node \n      children: \n      - 36\n      - 47\n      - 38\n      - 50\n      - 49\n      content_page_id: 12\n      controller_action_id: \n      id: 16\n      label: Inventory\n      name: Inventory\n      parent: \n      parent_id: \n      site_controller_id: \n      url: /Inventory\n    50: &id011 !ruby/object:Menu::Node \n      content_page_id: 19\n      controller_action_id: \n      id: 50\n      label: Reports\n      name: reports\n      parent: \n      parent_id: 16\n      site_controller_id: \n      url: /TBD\n    1: &id013 !ruby/object:Menu::Node \n      content_page_id: 1\n      controller_action_id: \n      id: 1\n      label: Home\n      name: home\n      parent: \n      parent_id: \n      site_controller_id: \n      url: /home\n    62: &id004 !ruby/object:Menu::Node \n      content_page_id: 19\n      controller_action_id: \n      id: 62\n      label: Notes\n      name: exp/notes\n      parent: \n      parent_id: 18\n      site_controller_id: \n      url: /TBD\n    18: &id008 !ruby/object:Menu::Node \n      children: \n      - 62\n      content_page_id: 16\n      controller_action_id: \n      id: 18\n      label: Experiment\n      name: Execution\n      parent: \n      parent_id: \n      site_controller_id: \n      url: /Execution\n    2: &id009 !ruby/object:Menu::Node \n      content_page_id: 6\n      controller_action_id: \n      id: 2\n      label: Contact Us\n      name: contact_us\n      parent: \n      parent_id: 9\n      site_controller_id: \n      url: /contact_us\n    47: &id003 !ruby/object:Menu::Node \n      content_page_id: 19\n      controller_action_id: \n      id: 47\n      label: Libraries\n      name: libraries\n      parent: \n      parent_id: 16\n      site_controller_id: \n      url: /TBD\n    36: &id012 !ruby/object:Menu::Node \n      content_page_id: 19\n      controller_action_id: \n      id: 36\n      label: Overview\n      name: inv/show\n      parent: \n      parent_id: 16\n      site_controller_id: \n      url: /TBD\n    14: &id010 !ruby/object:Menu::Node \n      content_page_id: 10\n      controller_action_id: \n      id: 14\n      label: Credits\n      name: credits\n      parent: \n      parent_id: 9\n      site_controller_id: \n      url: /credits\n    42: &id005 !ruby/object:Menu::Node \n      content_page_id: 19\n      controller_action_id: \n      id: 42\n      label: Notes\n      name: org/notes\n      parent: \n      parent_id: 17\n      site_controller_id: \n      url: /TBD\n    15: &id001 !ruby/object:Menu::Node \n      content_page_id: 11\n      controller_action_id: \n      id: 15\n      label: Catalogue\n      name: Catalogue\n      parent: \n      parent_id: \n      site_controller_id: \n      url: /Catalogue\n  by_name: \n    Catalogue: *id001\n    inv/notes: *id002\n    libraries: *id003\n    exp/notes: *id004\n    org/notes: *id005\n    inv/time: *id006\n    Inventory: *id007\n    Execution: *id008\n    contact_us: *id009\n    credits: *id010\n    reports: *id011\n    inv/show: *id012\n    home: *id013\n  crumbs: \n  - 1\n  root: &id014 !ruby/object:Menu::Node \n    children: \n    - 1\n    - 18\n    - 16\n    - 15\n    parent: \n  selected: \n    1: *id013\n  vector: \n  - *id014\n  - *id013\n','2006-06-23 11:03:49','2007-03-08 05:08:32'),(2,'Member',1,'',NULL,'--- \n:credentials: !ruby/object:Credentials \n  actions: \n    specimens: \n      list: true\n    containers: \n      list: true\n    experiments: \n      import_file: true\n      new: true\n      list: true\n      edit: true\n      timeline: true\n      show: true\n      reports: true\n    study_stages: \n      new: true\n      list: true\n      edit: true\n      destroy: true\n    studies: \n      new: true\n      list: true\n      parameters: true\n      edit: true\n      timeline: true\n      reports: true\n      protocols: true\n    parameter_roles: \n      new: true\n      list: true\n      edit: true\n      destroy: true\n    data_concepts: \n      list: false\n      edit: false\n      destroy: false\n      create: false\n      create_child: false\n      show: false\n      export: false\n      update: false\n    menu_items: \n      list: false\n      link: true\n    roles: \n      list: false\n    auth: \n      logout: true\n      login_failed: true\n      forgotten: true\n      login: true\n    catalogue: \n      new: true\n      add: true\n      list: true\n      edit: true\n      destroy: true\n      show: true\n      remove: true\n    site_controllers: \n      list: false\n    parameters: \n      list: true\n      show: true\n    study_parameters: \n      new: true\n      list: true\n      edit: true\n    data_systems: \n      new: true\n      list: true\n      edit: true\n      create: true\n      show: true\n      update: true\n    data_elements: \n      list: false\n      edit: false\n      destroy: false\n      create: false\n      create_child: false\n      show: false\n      export: false\n    study_queues: \n      new: true\n      list: true\n      edit: true\n      show: true\n    data_formats: \n      new: true\n      list: true\n      update: true\n    tasks: \n      new: true\n      list: true\n      sheet: true\n      edit: true\n      destroy: true\n      create: true\n      show: true\n      update: true\n    parameter_types: \n      new: true\n      list: true\n      edit: true\n      destroy: true\n    plates: \n      new: true\n      list: true\n      edit: true\n      destroy: true\n    data_contexts: \n      new: false\n      list: false\n      edit: false\n      destroy: false\n      create: false\n      show: false\n      export: false\n      update: false\n    requests: \n      new: true\n      list: true\n      edit: true\n      destroy: true\n    plate_formats: \n      list: true\n      show: true\n    batches: \n      list: true\n    compounds: \n      new: true\n      list: true\n      edit: true\n      destroy: false\n    data_types: \n      new: true\n      list: true\n      edit: true\n    users: \n      list: false\n    system_settings: \n      list: false\n    controller_actions: \n      list: false\n    permissions: \n      list: false\n    content_pages: \n      list: false\n      view_default: true\n      view: true\n    reports: \n      list: true\n      builder: true\n    samples: \n      list: true\n    study_protocols: \n      new: true\n      list: true\n      edit: true\n      destroy: true\n      create: true\n      update: true\n    finder: \n      query: true\n  controllers: \n    containers: true\n    specimens: true\n    experiments: true\n    study_stages: true\n    studies: true\n    parameter_roles: true\n    data_concepts: false\n    roles: false\n    menu_items: false\n    auth: false\n    catalogue: true\n    site_controllers: false\n    request_services: true\n    parameters: true\n    markup_styles: false\n    study_parameters: true\n    data_systems: true\n    treatment_groups: true\n    data_elements: false\n    data_capture: true\n    study_queues: true\n    roles_permissions: false\n    data_formats: true\n    tasks: true\n    parameter_types: true\n    plates: true\n    data_contexts: false\n    requests: true\n    plate_formats: true\n    batches: true\n    compounds: true\n    data_types: true\n    users: false\n    system_settings: false\n    permissions: false\n    controller_actions: false\n    content_pages: false\n    reports: true\n    samples: true\n    study_protocols: true\n    charts: true\n    finder: true\n  pages: \n    TBD: true\n    Catalogue: true\n    notfound: true\n    site_admin: false\n    Execution: true\n    Inventory: true\n    Analysis_Introduction: true\n    contact_us: true\n    Requesting: true\n    Organisation: false\n    credits: true\n    denied: true\n    expired: true\n    home: true\n    Study_Report: true\n  permission_ids: \n  - 5\n  - 4\n  - 3\n  role_id: 2\n  role_ids: \n  - 2\n  - 1\n  updated_at: 2007-03-08 05:08:32 +00:00\n:menu: !ruby/object:Menu \n  by_id: \n    49: &id015 !ruby/object:Menu::Node \n      content_page_id: 19\n      controller_action_id: \n      id: 49\n      label: Timeline\n      name: inv/time\n      parent: \n      parent_id: 16\n      site_controller_id: \n      url: /TBD\n    38: &id010 !ruby/object:Menu::Node \n      content_page_id: 19\n      controller_action_id: \n      id: 38\n      label: Notes\n      name: inv/notes\n      parent: \n      parent_id: 16\n      site_controller_id: \n      url: /TBD\n    27: &id019 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 69\n      id: 27\n      label: Parameter Types\n      name: catalog/parameter_types\n      parent: \n      parent_id: 15\n      site_controller_id: 21\n      url: /parameter_types/list\n    16: &id020 !ruby/object:Menu::Node \n      children: \n      - 36\n      - 45\n      - 47\n      - 46\n      - 48\n      - 38\n      - 50\n      - 49\n      content_page_id: 12\n      controller_action_id: \n      id: 16\n      label: Inventory\n      name: Inventory\n      parent: \n      parent_id: \n      site_controller_id: \n      url: /Inventory\n    44: &id022 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 106\n      id: 44\n      label: Data Entry\n      name: exe/data\n      parent: \n      parent_id: 18\n      site_controller_id: 32\n      url: /tasks/edit\n    22: &id027 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 114\n      id: 22\n      label: Data Types\n      name: catalog/datatype\n      parent: \n      parent_id: 15\n      site_controller_id: 33\n      url: /data_types/list\n    61: &id005 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 156\n      id: 61\n      label: Reports\n      name: exp/reports\n      parent: \n      parent_id: 18\n      site_controller_id: 31\n      url: /experiments/reports\n    28: &id023 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 117\n      id: 28\n      label: Protocols\n      name: org/protocol\n      parent: \n      parent_id: 17\n      site_controller_id: 26\n      url: /studies/protocols\n    50: &id031 !ruby/object:Menu::Node \n      content_page_id: 19\n      controller_action_id: \n      id: 50\n      label: Reports\n      name: reports\n      parent: \n      parent_id: 16\n      site_controller_id: \n      url: /TBD\n    39: &id004 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 65\n      id: 39\n      label: Parameter Roles\n      name: catalog/role\n      parent: \n      parent_id: 15\n      site_controller_id: 22\n      url: /parameter_roles/list\n    45: &id032 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 123\n      id: 45\n      label: Compounds\n      name: inv/compound\n      parent: \n      parent_id: 16\n      site_controller_id: 35\n      url: /compounds/list\n    1: &id035 !ruby/object:Menu::Node \n      children: \n      - 59\n      - 58\n      content_page_id: 1\n      controller_action_id: \n      id: 1\n      label: Home\n      name: home\n      parent: \n      parent_id: \n      site_controller_id: \n      url: /home\n    51: &id029 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 134\n      id: 51\n      label: Timeline\n      name: experimentr/timeline\n      parent: \n      parent_id: 18\n      site_controller_id: 31\n      url: /experiments/timeline\n    62: &id013 !ruby/object:Menu::Node \n      content_page_id: 19\n      controller_action_id: \n      id: 62\n      label: Notes\n      name: exp/notes\n      parent: \n      parent_id: 18\n      site_controller_id: \n      url: /TBD\n    40: &id017 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 128\n      id: 40\n      label: Timeline\n      name: org/time\n      parent: \n      parent_id: 17\n      site_controller_id: 26\n      url: /studies/timeline\n    18: &id021 !ruby/object:Menu::Node \n      children: \n      - 35\n      - 43\n      - 44\n      - 62\n      - 61\n      - 51\n      content_page_id: 16\n      controller_action_id: \n      id: 18\n      label: Experiment\n      name: Execution\n      parent: \n      parent_id: \n      site_controller_id: \n      url: /Execution\n    35: &id030 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 102\n      id: 35\n      label: Overview\n      name: exec/experiment\n      parent: \n      parent_id: 18\n      site_controller_id: 31\n      url: /experiments/list\n    46: &id011 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 127\n      id: 46\n      label: Batches\n      name: inv/batches\n      parent: \n      parent_id: 16\n      site_controller_id: 36\n      url: /batches/list\n    2: &id025 !ruby/object:Menu::Node \n      content_page_id: 6\n      controller_action_id: \n      id: 2\n      label: Contact Us\n      name: contact_us\n      parent: \n      parent_id: 9\n      site_controller_id: \n      url: /contact_us\n    41: &id006 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 148\n      id: 41\n      label: Reports\n      name: org/reports\n      parent: \n      parent_id: 17\n      site_controller_id: 26\n      url: /studies/reports\n    30: &id026 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 85\n      id: 30\n      label: Overview\n      name: org/study\n      parent: \n      parent_id: 17\n      site_controller_id: 26\n      url: /studies/list\n    63: &id007 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 146\n      id: 63\n      label: Report Builder\n      name: catalog/reports\n      parent: \n      parent_id: 15\n      site_controller_id: 48\n      url: /reports/list\n    19: &id034 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 150\n      id: 19\n      label: Data Dictionary\n      name: catalog/list\n      parent: \n      parent_id: 15\n      site_controller_id: 49\n      url: /catalogue/list\n    47: &id012 !ruby/object:Menu::Node \n      content_page_id: 19\n      controller_action_id: \n      id: 47\n      label: Libraries\n      name: libraries\n      parent: \n      parent_id: 16\n      site_controller_id: \n      url: /TBD\n    36: &id033 !ruby/object:Menu::Node \n      content_page_id: 19\n      controller_action_id: \n      id: 36\n      label: Overview\n      name: inv/show\n      parent: \n      parent_id: 16\n      site_controller_id: \n      url: /TBD\n    14: &id028 !ruby/object:Menu::Node \n      content_page_id: 10\n      controller_action_id: \n      id: 14\n      label: Credits\n      name: credits\n      parent: \n      parent_id: 9\n      site_controller_id: \n      url: /credits\n    58: &id008 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 143\n      id: 58\n      label: Requests\n      name: Home/Requests\n      parent: \n      parent_id: 1\n      site_controller_id: 47\n      url: /requests/list\n    42: &id014 !ruby/object:Menu::Node \n      content_page_id: 19\n      controller_action_id: \n      id: 42\n      label: Notes\n      name: org/notes\n      parent: \n      parent_id: 17\n      site_controller_id: \n      url: /TBD\n    31: &id003 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 92\n      id: 31\n      label: Study Stages\n      name: catalog/stages\n      parent: \n      parent_id: 15\n      site_controller_id: 27\n      url: /study_stages/list\n    20: &id036 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 120\n      id: 20\n      label: Data Formats\n      name: catalog/formats\n      parent: \n      parent_id: 15\n      site_controller_id: 34\n      url: /data_formats/list\n    26: &id018 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 118\n      id: 26\n      label: Parameters\n      name: org/params\n      parent: \n      parent_id: 17\n      site_controller_id: 26\n      url: /studies/parameters\n    48: &id002 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 61\n      id: 48\n      label: Plates & Samples\n      name: containers\n      parent: \n      parent_id: 16\n      site_controller_id: 20\n      url: /plates/list\n    59: &id016 !ruby/object:Menu::Node \n      content_page_id: 20\n      controller_action_id: \n      id: 59\n      label: Requirements\n      name: home/Requirements\n      parent: \n      parent_id: 1\n      site_controller_id: \n      url: /Requesting\n    15: &id009 !ruby/object:Menu::Node \n      children: \n      - 19\n      - 21\n      - 27\n      - 39\n      - 22\n      - 20\n      - 31\n      - 63\n      content_page_id: 11\n      controller_action_id: \n      id: 15\n      label: Catalogue\n      name: Catalogue\n      parent: \n      parent_id: \n      site_controller_id: \n      url: /Catalogue\n    43: &id001 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 119\n      id: 43\n      label: Schedule\n      name: exe/setup\n      parent: \n      parent_id: 18\n      site_controller_id: 31\n      url: /experiments/show\n    21: &id024 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 44\n      id: 21\n      label: Data Systems\n      name: catalog/systems\n      parent: \n      parent_id: 15\n      site_controller_id: 17\n      url: /data_systems/list\n  by_name: \n    exe/setup: *id001\n    containers: *id002\n    catalog/stages: *id003\n    catalog/role: *id004\n    exp/reports: *id005\n    org/reports: *id006\n    catalog/reports: *id007\n    Home/Requests: *id008\n    Catalogue: *id009\n    inv/notes: *id010\n    inv/batches: *id011\n    libraries: *id012\n    exp/notes: *id013\n    org/notes: *id014\n    inv/time: *id015\n    home/Requirements: *id016\n    org/time: *id017\n    org/params: *id018\n    catalog/parameter_types: *id019\n    Inventory: *id020\n    Execution: *id021\n    exe/data: *id022\n    org/protocol: *id023\n    catalog/systems: *id024\n    contact_us: *id025\n    org/study: *id026\n    catalog/datatype: *id027\n    credits: *id028\n    experimentr/timeline: *id029\n    exec/experiment: *id030\n    reports: *id031\n    inv/compound: *id032\n    inv/show: *id033\n    catalog/list: *id034\n    home: *id035\n    catalog/formats: *id036\n  crumbs: \n  - 1\n  root: &id037 !ruby/object:Menu::Node \n    children: \n    - 1\n    - 18\n    - 16\n    - 15\n    parent: \n  selected: \n    1: *id035\n  vector: \n  - *id037\n  - *id035\n','2006-06-23 11:03:50','2007-03-08 05:08:33'),(3,'Administrator',2,'',8,'--- \n:credentials: !ruby/object:Credentials \n  actions: \n    specimens: \n      list: true\n    containers: \n      list: true\n    experiments: \n      import_file: true\n      new: true\n      list: true\n      edit: true\n      timeline: true\n      show: true\n      reports: true\n    study_stages: \n      new: true\n      list: true\n      edit: true\n      destroy: true\n    studies: \n      new: true\n      list: true\n      parameters: true\n      edit: true\n      timeline: true\n      reports: true\n      protocols: true\n    parameter_roles: \n      new: true\n      list: true\n      edit: true\n      destroy: true\n    data_concepts: \n      list: true\n      edit: true\n      destroy: true\n      create: true\n      create_child: true\n      show: true\n      export: true\n      update: true\n    menu_items: \n      list: true\n      link: true\n    roles: \n      list: true\n    auth: \n      logout: true\n      login_failed: true\n      forgotten: true\n      login: true\n    catalogue: \n      new: true\n      add: true\n      list: true\n      edit: true\n      destroy: true\n      show: true\n      remove: true\n    site_controllers: \n      list: true\n    parameters: \n      list: true\n      show: true\n    study_parameters: \n      new: true\n      list: true\n      edit: true\n    data_systems: \n      new: true\n      list: true\n      edit: true\n      create: true\n      show: true\n      update: true\n    data_elements: \n      list: true\n      edit: true\n      destroy: true\n      create: true\n      create_child: true\n      show: true\n      export: true\n    study_queues: \n      new: true\n      list: true\n      edit: true\n      show: true\n    data_formats: \n      new: true\n      list: true\n      update: true\n    tasks: \n      new: true\n      list: true\n      sheet: true\n      edit: true\n      destroy: true\n      create: true\n      show: true\n      update: true\n    parameter_types: \n      new: true\n      list: true\n      edit: true\n      destroy: true\n    plates: \n      new: true\n      list: true\n      edit: true\n      destroy: true\n    data_contexts: \n      new: true\n      list: true\n      edit: true\n      destroy: true\n      create: true\n      show: true\n      export: true\n      update: true\n    requests: \n      new: true\n      list: true\n      edit: true\n      destroy: true\n    plate_formats: \n      list: true\n      show: true\n    batches: \n      list: true\n    compounds: \n      new: true\n      list: true\n      edit: true\n      destroy: true\n    data_types: \n      new: true\n      list: true\n      edit: true\n    users: \n      list: true\n    system_settings: \n      list: true\n    controller_actions: \n      list: true\n    permissions: \n      list: true\n    content_pages: \n      list: true\n      view_default: true\n      view: true\n    reports: \n      list: true\n      builder: true\n    samples: \n      list: true\n    study_protocols: \n      new: true\n      list: true\n      edit: true\n      destroy: true\n      create: true\n      update: true\n    finder: \n      query: true\n  controllers: \n    containers: true\n    specimens: true\n    experiments: true\n    study_stages: true\n    studies: true\n    parameter_roles: true\n    data_concepts: true\n    roles: true\n    menu_items: true\n    auth: true\n    catalogue: true\n    site_controllers: true\n    request_services: true\n    parameters: true\n    markup_styles: true\n    study_parameters: true\n    data_systems: true\n    treatment_groups: true\n    data_elements: true\n    data_capture: true\n    study_queues: true\n    roles_permissions: true\n    data_formats: true\n    tasks: true\n    parameter_types: true\n    plates: true\n    data_contexts: true\n    requests: true\n    plate_formats: true\n    batches: true\n    compounds: true\n    data_types: true\n    users: true\n    system_settings: true\n    permissions: true\n    controller_actions: true\n    content_pages: true\n    reports: true\n    samples: true\n    study_protocols: true\n    charts: true\n    finder: true\n  pages: \n    TBD: true\n    Catalogue: true\n    notfound: true\n    site_admin: true\n    Execution: true\n    Inventory: true\n    Analysis_Introduction: true\n    contact_us: true\n    Requesting: true\n    Organisation: true\n    credits: true\n    denied: true\n    expired: true\n    home: true\n    Study_Report: true\n  permission_ids: \n  - 1\n  - 5\n  - 4\n  - 2\n  - 3\n  role_id: 3\n  role_ids: \n  - 3\n  - 2\n  - 1\n  updated_at: 2007-03-08 05:08:33 +00:00\n:menu: !ruby/object:Menu \n  by_id: \n    49: &id019 !ruby/object:Menu::Node \n      content_page_id: 19\n      controller_action_id: \n      id: 49\n      label: Timeline\n      name: inv/time\n      parent: \n      parent_id: 16\n      site_controller_id: \n      url: /TBD\n    38: &id014 !ruby/object:Menu::Node \n      content_page_id: 19\n      controller_action_id: \n      id: 38\n      label: Notes\n      name: inv/notes\n      parent: \n      parent_id: 16\n      site_controller_id: \n      url: /TBD\n    27: &id024 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 69\n      id: 27\n      label: Parameter Types\n      name: catalog/parameter_types\n      parent: \n      parent_id: 15\n      site_controller_id: 21\n      url: /parameter_types/list\n    5: &id031 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 4\n      id: 5\n      label: Permissions\n      name: setup/permissions\n      parent: \n      parent_id: 9\n      site_controller_id: 6\n      url: /permissions/list\n    16: &id025 !ruby/object:Menu::Node \n      children: \n      - 36\n      - 45\n      - 47\n      - 46\n      - 48\n      - 38\n      - 50\n      - 49\n      content_page_id: 12\n      controller_action_id: \n      id: 16\n      label: Inventory\n      name: Inventory\n      parent: \n      parent_id: \n      site_controller_id: \n      url: /Inventory\n    44: &id027 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 106\n      id: 44\n      label: Data Entry\n      name: exe/data\n      parent: \n      parent_id: 18\n      site_controller_id: 32\n      url: /tasks/edit\n    22: &id034 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 114\n      id: 22\n      label: Data Types\n      name: catalog/datatype\n      parent: \n      parent_id: 15\n      site_controller_id: 33\n      url: /data_types/list\n    11: &id011 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 11\n      id: 11\n      label: Menu Editor\n      name: setup/menus\n      parent: \n      parent_id: 9\n      site_controller_id: 5\n      url: /menu_items/list\n    61: &id008 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 156\n      id: 61\n      label: Reports\n      name: exp/reports\n      parent: \n      parent_id: 18\n      site_controller_id: 31\n      url: /experiments/reports\n    28: &id028 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 117\n      id: 28\n      label: Protocols\n      name: org/protocol\n      parent: \n      parent_id: 17\n      site_controller_id: 26\n      url: /studies/protocols\n    50: &id039 !ruby/object:Menu::Node \n      content_page_id: 19\n      controller_action_id: \n      id: 50\n      label: Reports\n      name: reports\n      parent: \n      parent_id: 16\n      site_controller_id: \n      url: /TBD\n    39: &id006 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 65\n      id: 39\n      label: Parameter Roles\n      name: catalog/role\n      parent: \n      parent_id: 15\n      site_controller_id: 22\n      url: /parameter_roles/list\n    6: &id020 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 3\n      id: 6\n      label: Roles\n      name: setup/roles\n      parent: \n      parent_id: 9\n      site_controller_id: 7\n      url: /roles/list\n    17: &id036 !ruby/object:Menu::Node \n      children: \n      - 30\n      - 26\n      - 28\n      - 42\n      - 41\n      - 40\n      content_page_id: 14\n      controller_action_id: \n      id: 17\n      label: Study\n      name: Organisation\n      parent: \n      parent_id: \n      site_controller_id: \n      url: /Organisation\n    45: &id040 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 123\n      id: 45\n      label: Compounds\n      name: inv/compound\n      parent: \n      parent_id: 16\n      site_controller_id: 35\n      url: /compounds/list\n    12: &id007 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 12\n      id: 12\n      label: System Settings\n      name: setup/system_settings\n      parent: \n      parent_id: 9\n      site_controller_id: 9\n      url: /system_settings/list\n    1: &id044 !ruby/object:Menu::Node \n      children: \n      - 59\n      - 58\n      content_page_id: 1\n      controller_action_id: \n      id: 1\n      label: Home\n      name: home\n      parent: \n      parent_id: \n      site_controller_id: \n      url: /home\n    51: &id037 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 134\n      id: 51\n      label: Timeline\n      name: experimentr/timeline\n      parent: \n      parent_id: 18\n      site_controller_id: 31\n      url: /experiments/timeline\n    62: &id017 !ruby/object:Menu::Node \n      content_page_id: 19\n      controller_action_id: \n      id: 62\n      label: Notes\n      name: exp/notes\n      parent: \n      parent_id: 18\n      site_controller_id: \n      url: /TBD\n    40: &id022 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 128\n      id: 40\n      label: Timeline\n      name: org/time\n      parent: \n      parent_id: 17\n      site_controller_id: 26\n      url: /studies/timeline\n    7: &id004 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 8\n      id: 7\n      label: Content Pages\n      name: setup/pages\n      parent: \n      parent_id: 9\n      site_controller_id: 1\n      url: /content_pages/list\n    18: &id026 !ruby/object:Menu::Node \n      children: \n      - 35\n      - 43\n      - 44\n      - 62\n      - 61\n      - 51\n      content_page_id: 16\n      controller_action_id: \n      id: 18\n      label: Experiment\n      name: Execution\n      parent: \n      parent_id: \n      site_controller_id: \n      url: /Execution\n    35: &id038 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 102\n      id: 35\n      label: Overview\n      name: exec/experiment\n      parent: \n      parent_id: 18\n      site_controller_id: 31\n      url: /experiments/list\n    46: &id015 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 127\n      id: 46\n      label: Batches\n      name: inv/batches\n      parent: \n      parent_id: 16\n      site_controller_id: 36\n      url: /batches/list\n    2: &id030 !ruby/object:Menu::Node \n      content_page_id: 6\n      controller_action_id: \n      id: 2\n      label: Contact Us\n      name: contact_us\n      parent: \n      parent_id: 9\n      site_controller_id: \n      url: /contact_us\n    13: &id005 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 15\n      id: 13\n      label: Users\n      name: setup/users\n      parent: \n      parent_id: 9\n      site_controller_id: 10\n      url: /users/list\n    41: &id009 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 148\n      id: 41\n      label: Reports\n      name: org/reports\n      parent: \n      parent_id: 17\n      site_controller_id: 26\n      url: /studies/reports\n    30: &id033 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 85\n      id: 30\n      label: Overview\n      name: org/study\n      parent: \n      parent_id: 17\n      site_controller_id: 26\n      url: /studies/list\n    63: &id010 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 146\n      id: 63\n      label: Report Builder\n      name: catalog/reports\n      parent: \n      parent_id: 15\n      site_controller_id: 48\n      url: /reports/list\n    19: &id042 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 150\n      id: 19\n      label: Data Dictionary\n      name: catalog/list\n      parent: \n      parent_id: 15\n      site_controller_id: 49\n      url: /catalogue/list\n    8: &id043 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 9\n      id: 8\n      label: Controllers\n      name: setup/controllers\n      parent: \n      parent_id: 9\n      site_controller_id: 8\n      url: /site_controllers/list\n    47: &id016 !ruby/object:Menu::Node \n      content_page_id: 19\n      controller_action_id: \n      id: 47\n      label: Libraries\n      name: libraries\n      parent: \n      parent_id: 16\n      site_controller_id: \n      url: /TBD\n    36: &id041 !ruby/object:Menu::Node \n      content_page_id: 19\n      controller_action_id: \n      id: 36\n      label: Overview\n      name: inv/show\n      parent: \n      parent_id: 16\n      site_controller_id: \n      url: /TBD\n    14: &id035 !ruby/object:Menu::Node \n      content_page_id: 10\n      controller_action_id: \n      id: 14\n      label: Credits\n      name: credits\n      parent: \n      parent_id: 9\n      site_controller_id: \n      url: /credits\n    58: &id012 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 143\n      id: 58\n      label: Requests\n      name: Home/Requests\n      parent: \n      parent_id: 1\n      site_controller_id: 47\n      url: /requests/list\n    42: &id018 !ruby/object:Menu::Node \n      content_page_id: 19\n      controller_action_id: \n      id: 42\n      label: Notes\n      name: org/notes\n      parent: \n      parent_id: 17\n      site_controller_id: \n      url: /TBD\n    31: &id003 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 92\n      id: 31\n      label: Study Stages\n      name: catalog/stages\n      parent: \n      parent_id: 15\n      site_controller_id: 27\n      url: /study_stages/list\n    20: &id045 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 120\n      id: 20\n      label: Data Formats\n      name: catalog/formats\n      parent: \n      parent_id: 15\n      site_controller_id: 34\n      url: /data_formats/list\n    9: &id032 !ruby/object:Menu::Node \n      children: \n      - 13\n      - 6\n      - 5\n      - 11\n      - 8\n      - 7\n      - 12\n      - 2\n      - 14\n      content_page_id: 8\n      controller_action_id: \n      id: 9\n      label: Setup\n      name: setup\n      parent: \n      parent_id: \n      site_controller_id: \n      url: /site_admin\n    26: &id023 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 118\n      id: 26\n      label: Parameters\n      name: org/params\n      parent: \n      parent_id: 17\n      site_controller_id: 26\n      url: /studies/parameters\n    48: &id002 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 61\n      id: 48\n      label: Plates & Samples\n      name: containers\n      parent: \n      parent_id: 16\n      site_controller_id: 20\n      url: /plates/list\n    59: &id021 !ruby/object:Menu::Node \n      content_page_id: 20\n      controller_action_id: \n      id: 59\n      label: Requirements\n      name: home/Requirements\n      parent: \n      parent_id: 1\n      site_controller_id: \n      url: /Requesting\n    15: &id013 !ruby/object:Menu::Node \n      children: \n      - 19\n      - 21\n      - 27\n      - 39\n      - 22\n      - 20\n      - 31\n      - 63\n      content_page_id: 11\n      controller_action_id: \n      id: 15\n      label: Catalogue\n      name: Catalogue\n      parent: \n      parent_id: \n      site_controller_id: \n      url: /Catalogue\n    43: &id001 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 119\n      id: 43\n      label: Schedule\n      name: exe/setup\n      parent: \n      parent_id: 18\n      site_controller_id: 31\n      url: /experiments/show\n    21: &id029 !ruby/object:Menu::Node \n      content_page_id: \n      controller_action_id: 44\n      id: 21\n      label: Data Systems\n      name: catalog/systems\n      parent: \n      parent_id: 15\n      site_controller_id: 17\n      url: /data_systems/list\n  by_name: \n    exe/setup: *id001\n    containers: *id002\n    catalog/stages: *id003\n    setup/pages: *id004\n    setup/users: *id005\n    catalog/role: *id006\n    setup/system_settings: *id007\n    exp/reports: *id008\n    org/reports: *id009\n    catalog/reports: *id010\n    setup/menus: *id011\n    Home/Requests: *id012\n    Catalogue: *id013\n    inv/notes: *id014\n    inv/batches: *id015\n    libraries: *id016\n    exp/notes: *id017\n    org/notes: *id018\n    inv/time: *id019\n    setup/roles: *id020\n    home/Requirements: *id021\n    org/time: *id022\n    org/params: *id023\n    catalog/parameter_types: *id024\n    Inventory: *id025\n    Execution: *id026\n    exe/data: *id027\n    org/protocol: *id028\n    catalog/systems: *id029\n    contact_us: *id030\n    setup/permissions: *id031\n    setup: *id032\n    org/study: *id033\n    catalog/datatype: *id034\n    credits: *id035\n    Organisation: *id036\n    experimentr/timeline: *id037\n    exec/experiment: *id038\n    reports: *id039\n    inv/compound: *id040\n    inv/show: *id041\n    catalog/list: *id042\n    setup/controllers: *id043\n    home: *id044\n    catalog/formats: *id045\n  crumbs: \n  - 1\n  root: &id046 !ruby/object:Menu::Node \n    children: \n    - 1\n    - 17\n    - 18\n    - 16\n    - 15\n    - 9\n    parent: \n  selected: \n    1: *id044\n  vector: \n  - *id046\n  - *id044\n','2006-06-23 11:03:48','2007-03-08 05:08:33');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;

--
-- Table structure for table `roles_permissions`
--

DROP TABLE IF EXISTS `roles_permissions`;
CREATE TABLE `roles_permissions` (
  `id` int(11) NOT NULL auto_increment,
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_roles_permission_role_id` (`role_id`),
  KEY `fk_roles_permission_permission_id` (`permission_id`),
  CONSTRAINT `fk_roles_permission_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_roles_permission_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `roles_permissions`
--


/*!40000 ALTER TABLE `roles_permissions` DISABLE KEYS */;
INSERT INTO `roles_permissions` VALUES (4,3,1),(6,1,3),(7,3,2),(9,1,4),(10,2,5);
/*!40000 ALTER TABLE `roles_permissions` ENABLE KEYS */;

--
-- Table structure for table `samples`
--

DROP TABLE IF EXISTS `samples`;
CREATE TABLE `samples` (
  `id` int(11) NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `samples`
--


/*!40000 ALTER TABLE `samples` DISABLE KEYS */;
/*!40000 ALTER TABLE `samples` ENABLE KEYS */;

--
-- Table structure for table `schema_info`
--

DROP TABLE IF EXISTS `schema_info`;
CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `schema_info`
--


/*!40000 ALTER TABLE `schema_info` DISABLE KEYS */;
INSERT INTO `schema_info` VALUES (127);
/*!40000 ALTER TABLE `schema_info` ENABLE KEYS */;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) NOT NULL,
  `data` longtext,
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `sessions`
--


/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;

--
-- Table structure for table `site_controllers`
--

DROP TABLE IF EXISTS `site_controllers`;
CREATE TABLE `site_controllers` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `permission_id` int(11) NOT NULL,
  `builtin` int(10) unsigned default '0',
  PRIMARY KEY  (`id`),
  KEY `fk_site_controller_permission_id` (`permission_id`),
  CONSTRAINT `fk_site_controller_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `site_controllers`
--


/*!40000 ALTER TABLE `site_controllers` DISABLE KEYS */;
INSERT INTO `site_controllers` VALUES (1,'content_pages',1,1),(2,'controller_actions',1,1),(3,'auth',1,1),(4,'markup_styles',1,1),(5,'menu_items',1,1),(6,'permissions',1,1),(7,'roles',1,1),(8,'site_controllers',1,1),(9,'system_settings',1,1),(10,'users',1,1),(11,'roles_permissions',1,1),(13,'data_contexts',1,0),(14,'data_concepts',1,0),(16,'data_elements',1,0),(17,'data_systems',5,0),(20,'plates',5,0),(21,'parameter_types',5,0),(22,'parameter_roles',5,0),(26,'studies',5,0),(27,'study_stages',5,0),(28,'study_parameters',5,0),(29,'study_protocols',5,0),(30,'finder',5,0),(31,'experiments',5,0),(32,'tasks',5,0),(33,'data_types',5,0),(34,'data_formats',5,0),(35,'compounds',5,0),(36,'batches',5,0),(37,'specimens',5,0),(38,'containers',5,0),(39,'treatment_groups',5,0),(40,'plate_formats',5,0),(41,'samples',5,0),(43,'charts',5,0),(44,'study_queues',5,0),(47,'requests',5,0),(48,'reports',5,0),(49,'catalogue',5,0),(50,'parameters',5,0),(51,'request_services',5,0),(52,'data_capture',4,0);
/*!40000 ALTER TABLE `site_controllers` ENABLE KEYS */;

--
-- Table structure for table `specimens`
--

DROP TABLE IF EXISTS `specimens`;
CREATE TABLE `specimens` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `weight` float default NULL,
  `sex` varchar(255) default NULL,
  `birth` datetime default NULL,
  `age` datetime default NULL,
  `taxon_domain` varchar(255) default NULL,
  `taxon_kingdom` varchar(255) default NULL,
  `taxon_phylum` varchar(255) default NULL,
  `taxon_class` varchar(255) default NULL,
  `taxon_family` varchar(255) default NULL,
  `taxon_order` varchar(255) default NULL,
  `taxon_genus` varchar(255) default NULL,
  `taxon_species` varchar(255) default NULL,
  `taxon_subspecies` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `specimens`
--


/*!40000 ALTER TABLE `specimens` DISABLE KEYS */;
INSERT INTO `specimens` VALUES (1,'Mooose','Large mammal',NULL,'','2006-12-18 22:44:52','2006-12-18 22:44:52','','','','','','','','','',0,'','2006-12-18 22:46:00','','2006-12-18 22:46:00');
/*!40000 ALTER TABLE `specimens` ENABLE KEYS */;

--
-- Table structure for table `studies`
--

DROP TABLE IF EXISTS `studies`;
CREATE TABLE `studies` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `category_id` int(11) default NULL,
  `research_area` varchar(255) default NULL,
  `purpose` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `studies_name_index` (`name`),
  KEY `studies_updated_by_index` (`updated_by`),
  KEY `studies_updated_at_index` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `studies`
--


/*!40000 ALTER TABLE `studies` DISABLE KEYS */;
INSERT INTO `studies` VALUES (1,'Biomarker And Histology','A synchronous study covering multiple groups using different techniques and employing request fulfillment to progress the animals under investigation through the three tiers of testing: weight monitoring, taqman analysis and histological analysis.',NULL,'in-vivo','RF',0,'','2007-03-20 16:05:00','','2007-03-20 16:05:00'),(2,'RES Exposure','An example behavioural study',NULL,'Behavioural','Case Study',2,'','2007-03-21 09:34:46','','2007-03-21 10:44:45'),(3,'Screen','<h3>Purpose&nbsp;</h3><p>This example demostrates the running of a full screen, from the registration of mother and assay plates to the generation of the screening report&nbsp;</p>',NULL,'screening','demo',0,'','2007-03-21 12:49:02','','2007-03-21 12:49:02');
/*!40000 ALTER TABLE `studies` ENABLE KEYS */;

--
-- Table structure for table `study_logs`
--

DROP TABLE IF EXISTS `study_logs`;
CREATE TABLE `study_logs` (
  `id` int(11) NOT NULL auto_increment,
  `study_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `auditable_id` int(11) default NULL,
  `auditable_type` varchar(255) default NULL,
  `action` varchar(255) default NULL,
  `name` varchar(255) default NULL,
  `comment` varchar(255) default NULL,
  `changes` text,
  `created_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `study_logs_study_id_index` (`study_id`),
  KEY `study_logs_user_id_index` (`user_id`),
  KEY `study_logs_auditable_type_index` (`auditable_type`,`auditable_id`),
  KEY `study_logs_created_at_index` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `study_logs`
--


/*!40000 ALTER TABLE `study_logs` DISABLE KEYS */;
INSERT INTO `study_logs` VALUES (1,1,NULL,1,'Study','Create','Biomarker And Histology',' Create study Biomarker And Histology',NULL,NULL,'2007-03-20 16:05:00'),(2,1,NULL,1,'StudyParameter','Create','Score',' Create parameter Score in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:07:43'),(3,1,NULL,1,'StudyParameter','Update','Score',' Update parameter Score in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:07:43'),(4,1,NULL,2,'StudyParameter','Create','Weight',' Create parameter Weight in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:08:24'),(5,1,NULL,2,'StudyParameter','Update','Weight',' Update parameter Weight in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:08:24'),(6,1,NULL,2,'StudyParameter','Update','Weight',' Update parameter Weight in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:09:21'),(7,1,NULL,3,'StudyParameter','Create','Reading',' Create parameter Reading in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:10:34'),(8,1,NULL,3,'StudyParameter','Update','Reading',' Update parameter Reading in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:10:34'),(9,1,NULL,4,'StudyParameter','Create','p',' Create parameter p in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:11:54'),(10,1,NULL,4,'StudyParameter','Update','p',' Update parameter p in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:11:54'),(11,1,NULL,5,'StudyParameter','Create','sig',' Create parameter sig in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:14:06'),(12,1,NULL,5,'StudyParameter','Update','sig',' Update parameter sig in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:14:06'),(13,1,NULL,6,'StudyParameter','Create','Treatment Role',' Create parameter Treatment Role in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:14:41'),(14,1,NULL,6,'StudyParameter','Update','Treatment Role',' Update parameter Treatment Role in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:14:41'),(15,1,NULL,7,'StudyParameter','Create','Index',' Create parameter Index in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:15:07'),(16,1,NULL,7,'StudyParameter','Update','Index',' Update parameter Index in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:15:07'),(17,1,NULL,8,'StudyParameter','Create','Treatment Group',' Create parameter Treatment Group in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:15:36'),(18,1,NULL,8,'StudyParameter','Update','Treatment Group',' Update parameter Treatment Group in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:15:36'),(19,1,NULL,9,'StudyParameter','Create','Group Size',' Create parameter Group Size in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:16:05'),(20,1,NULL,9,'StudyParameter','Update','Group Size',' Update parameter Group Size in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:16:05'),(21,1,NULL,10,'StudyParameter','Create','Gene',' Create parameter Gene in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:16:46'),(22,1,NULL,10,'StudyParameter','Update','Gene',' Update parameter Gene in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:16:46'),(23,1,NULL,11,'StudyParameter','Create','Molecular Mass',' Create parameter Molecular Mass in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:17:19'),(24,1,NULL,11,'StudyParameter','Update','Molecular Mass',' Update parameter Molecular Mass in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:17:19'),(25,1,NULL,12,'StudyParameter','Create','Min Weight',' Create parameter Min Weight in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:18:04'),(26,1,NULL,12,'StudyParameter','Update','Min Weight',' Update parameter Min Weight in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:18:04'),(27,1,NULL,13,'StudyParameter','Create','Min Age',' Create parameter Min Age in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:18:35'),(28,1,NULL,13,'StudyParameter','Update','Min Age',' Update parameter Min Age in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:18:35'),(29,1,NULL,14,'StudyParameter','Create','Molecula Formula',' Create parameter Molecula Formula in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:19:18'),(30,1,NULL,14,'StudyParameter','Update','Molecula Formula',' Update parameter Molecula Formula in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:19:18'),(31,1,NULL,11,'StudyParameter','Update','Molecular Mass',' Update parameter Molecular Mass in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:19:39'),(32,1,NULL,9,'StudyParameter','Update','Group Size',' Update parameter Group Size in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:19:59'),(33,1,NULL,15,'StudyParameter','Create','Compound',' Create parameter Compound in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:24:03'),(34,1,NULL,15,'StudyParameter','Update','Compound',' Update parameter Compound in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:24:03'),(35,1,NULL,16,'StudyParameter','Create','Date',' Create parameter Date in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:25:26'),(36,1,NULL,16,'StudyParameter','Update','Date',' Update parameter Date in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:25:26'),(37,1,NULL,17,'StudyParameter','Create','Age',' Create parameter Age in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:28:44'),(38,1,NULL,17,'StudyParameter','Update','Age',' Update parameter Age in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:28:44'),(39,1,NULL,18,'StudyParameter','Create','Age',' Create parameter Age in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:32:53'),(40,1,NULL,18,'StudyParameter','Update','Age',' Update parameter Age in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:32:53'),(41,1,NULL,19,'StudyParameter','Create','Species',' Create parameter Species in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:35:07'),(42,1,NULL,19,'StudyParameter','Update','Species',' Update parameter Species in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:35:07'),(43,1,NULL,19,'StudyParameter','Update','Species',' Update parameter Species in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:35:36'),(44,1,NULL,20,'StudyParameter','Create','Day',' Create parameter Day in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:37:35'),(45,1,NULL,20,'StudyParameter','Update','Day',' Update parameter Day in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:37:36'),(46,1,NULL,21,'StudyParameter','Create','ID',' Create parameter ID in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:38:06'),(47,1,NULL,21,'StudyParameter','Update','ID',' Update parameter ID in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:38:06'),(48,1,NULL,22,'StudyParameter','Create','Strain',' Create parameter Strain in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:38:39'),(49,1,NULL,22,'StudyParameter','Update','Strain',' Update parameter Strain in study Biomarker And Histology',NULL,NULL,'2007-03-20 16:38:39'),(50,1,NULL,23,'StudyParameter','Create','Calculation',' Create parameter Calculation in study Biomarker And Histology',NULL,NULL,'2007-03-20 18:42:08'),(51,1,NULL,23,'StudyParameter','Update','Calculation',' Update parameter Calculation in study Biomarker And Histology',NULL,NULL,'2007-03-20 18:42:08'),(52,1,NULL,1,'StudyProtocol','Create','Materials',' Create protocol Materials in study Biomarker And Histology',NULL,NULL,'2007-03-20 19:50:48'),(53,1,NULL,1,'StudyProtocol','Update','Materials',' Update protocol Materials in study Biomarker And Histology',NULL,NULL,'2007-03-20 19:50:48'),(54,1,NULL,2,'StudyProtocol','Create','Animals',' Create protocol Animals in study Biomarker And Histology',NULL,NULL,'2007-03-20 20:05:26'),(55,1,NULL,2,'StudyProtocol','Update','Animals',' Update protocol Animals in study Biomarker And Histology',NULL,NULL,'2007-03-20 20:05:26'),(56,1,NULL,3,'StudyProtocol','Create','Treatments',' Create protocol Treatments in study Biomarker And Histology',NULL,NULL,'2007-03-20 20:09:03'),(57,1,NULL,3,'StudyProtocol','Update','Treatments',' Update protocol Treatments in study Biomarker And Histology',NULL,NULL,'2007-03-20 20:09:03'),(58,1,NULL,4,'StudyProtocol','Create','Weights',' Create protocol Weights in study Biomarker And Histology',NULL,NULL,'2007-03-20 20:54:26'),(59,1,NULL,4,'StudyProtocol','Update','Weights',' Update protocol Weights in study Biomarker And Histology',NULL,NULL,'2007-03-20 20:54:27'),(60,1,NULL,4,'StudyProtocol','Update','Weights',' Update protocol Weights in study Biomarker And Histology',NULL,NULL,'2007-03-20 20:55:11'),(61,1,NULL,5,'StudyProtocol','Create','Weight Summary',' Create protocol Weight Summary in study Biomarker And Histology',NULL,NULL,'2007-03-20 21:00:33'),(62,1,NULL,5,'StudyProtocol','Update','Weight Summary',' Update protocol Weight Summary in study Biomarker And Histology',NULL,NULL,'2007-03-20 21:00:33'),(63,1,NULL,24,'StudyParameter','Create','Statistic',' Create parameter Statistic in study Biomarker And Histology',NULL,NULL,'2007-03-20 21:04:51'),(64,1,NULL,24,'StudyParameter','Update','Statistic',' Update parameter Statistic in study Biomarker And Histology',NULL,NULL,'2007-03-20 21:04:51'),(65,1,NULL,6,'StudyProtocol','Create','Taqman',' Create protocol Taqman in study Biomarker And Histology',NULL,NULL,'2007-03-20 21:15:22'),(66,1,NULL,6,'StudyProtocol','Update','Taqman',' Update protocol Taqman in study Biomarker And Histology',NULL,NULL,'2007-03-20 21:15:22'),(67,1,NULL,6,'StudyProtocol','Update','Taqman',' Update protocol Taqman in study Biomarker And Histology',NULL,NULL,'2007-03-20 21:15:38'),(68,1,NULL,6,'StudyProtocol','Update','Taqman Readings',' Update protocol Taqman Readings in study Biomarker And Histology',NULL,NULL,'2007-03-20 21:20:28'),(69,1,NULL,7,'StudyProtocol','Create','Taqman Analysis',' Create protocol Taqman Analysis in study Biomarker And Histology',NULL,NULL,'2007-03-20 21:22:37'),(70,1,NULL,7,'StudyProtocol','Update','Taqman Analysis',' Update protocol Taqman Analysis in study Biomarker And Histology',NULL,NULL,'2007-03-20 21:22:37'),(71,1,NULL,25,'StudyParameter','Create','Flag',' Create parameter Flag in study Biomarker And Histology',NULL,NULL,'2007-03-20 21:24:00'),(72,1,NULL,25,'StudyParameter','Update','Flag',' Update parameter Flag in study Biomarker And Histology',NULL,NULL,'2007-03-20 21:24:00'),(73,1,NULL,25,'StudyParameter','Update','Histology',' Update parameter Histology in study Biomarker And Histology',NULL,NULL,'2007-03-20 21:26:02'),(74,1,NULL,8,'StudyProtocol','Create','Histological Scoring',' Create protocol Histological Scoring in study Biomarker And Histology',NULL,NULL,'2007-03-20 21:31:18'),(75,1,NULL,8,'StudyProtocol','Update','Histological Scoring',' Update protocol Histological Scoring in study Biomarker And Histology',NULL,NULL,'2007-03-20 21:31:18'),(76,2,NULL,2,'Study','Create','RES Exposure',' Create study RES Exposure',NULL,NULL,'2007-03-21 09:34:46'),(77,2,NULL,26,'StudyParameter','Create','Index',' Create parameter Index in study RES Exposure',NULL,NULL,'2007-03-21 09:35:43'),(78,2,NULL,26,'StudyParameter','Update','Index',' Update parameter Index in study RES Exposure',NULL,NULL,'2007-03-21 09:35:43'),(79,2,NULL,27,'StudyParameter','Create','Time',' Create parameter Time in study RES Exposure',NULL,NULL,'2007-03-21 09:36:36'),(80,2,NULL,27,'StudyParameter','Update','Time',' Update parameter Time in study RES Exposure',NULL,NULL,'2007-03-21 09:36:36'),(81,2,NULL,28,'StudyParameter','Create','ActivityCount',' Create parameter ActivityCount in study RES Exposure',NULL,NULL,'2007-03-21 09:37:33'),(82,2,NULL,28,'StudyParameter','Update','ActivityCount',' Update parameter ActivityCount in study RES Exposure',NULL,NULL,'2007-03-21 09:37:33'),(83,2,NULL,29,'StudyParameter','Create','Compound',' Create parameter Compound in study RES Exposure',NULL,NULL,'2007-03-21 09:39:02'),(84,2,NULL,29,'StudyParameter','Update','Compound',' Update parameter Compound in study RES Exposure',NULL,NULL,'2007-03-21 09:39:02'),(85,2,NULL,30,'StudyParameter','Create','Label',' Create parameter Label in study RES Exposure',NULL,NULL,'2007-03-21 09:40:29'),(86,2,NULL,30,'StudyParameter','Update','Label',' Update parameter Label in study RES Exposure',NULL,NULL,'2007-03-21 09:40:29'),(87,2,NULL,31,'StudyParameter','Create','Treatment Role',' Create parameter Treatment Role in study RES Exposure',NULL,NULL,'2007-03-21 09:41:49'),(88,2,NULL,31,'StudyParameter','Update','Treatment Role',' Update parameter Treatment Role in study RES Exposure',NULL,NULL,'2007-03-21 09:41:49'),(89,2,NULL,32,'StudyParameter','Create','Concentration',' Create parameter Concentration in study RES Exposure',NULL,NULL,'2007-03-21 09:42:41'),(90,2,NULL,32,'StudyParameter','Update','Concentration',' Update parameter Concentration in study RES Exposure',NULL,NULL,'2007-03-21 09:42:41'),(91,2,NULL,33,'StudyParameter','Create','Group Size',' Create parameter Group Size in study RES Exposure',NULL,NULL,'2007-03-21 09:45:50'),(92,2,NULL,33,'StudyParameter','Update','Group Size',' Update parameter Group Size in study RES Exposure',NULL,NULL,'2007-03-21 09:45:50'),(93,2,NULL,9,'StudyProtocol','Create','Setup Materials and Groups',' Create protocol Setup Materials and Groups in study RES Exposure',NULL,NULL,'2007-03-21 09:51:33'),(94,2,NULL,9,'StudyProtocol','Update','Setup Materials and Groups',' Update protocol Setup Materials and Groups in study RES Exposure',NULL,NULL,'2007-03-21 09:51:33'),(95,2,NULL,10,'StudyProtocol','Create','Capture Raw Data',' Create protocol Capture Raw Data in study RES Exposure',NULL,NULL,'2007-03-21 10:07:13'),(96,2,NULL,10,'StudyProtocol','Update','Capture Raw Data',' Update protocol Capture Raw Data in study RES Exposure',NULL,NULL,'2007-03-21 10:07:13'),(97,2,NULL,11,'StudyProtocol','Create','ED50 Calculation',' Create protocol ED50 Calculation in study RES Exposure',NULL,NULL,'2007-03-21 10:32:26'),(98,2,NULL,11,'StudyProtocol','Update','ED50 Calculation',' Update protocol ED50 Calculation in study RES Exposure',NULL,NULL,'2007-03-21 10:32:26'),(99,2,NULL,2,'Study','Update','RES Exposure',' Update study RES Exposure',NULL,NULL,'2007-03-21 10:44:45'),(100,2,NULL,2,'Study','Update','RES Exposure',' Update study RES Exposure',NULL,NULL,'2007-03-21 10:44:45'),(101,2,NULL,34,'StudyParameter','Create','Inhibition',' Create parameter Inhibition in study RES Exposure',NULL,NULL,'2007-03-21 10:59:19'),(102,2,NULL,34,'StudyParameter','Update','Inhibition',' Update parameter Inhibition in study RES Exposure',NULL,NULL,'2007-03-21 10:59:19'),(103,2,NULL,35,'StudyParameter','Create','ED50',' Create parameter ED50 in study RES Exposure',NULL,NULL,'2007-03-21 11:01:39'),(104,2,NULL,35,'StudyParameter','Update','ED50',' Update parameter ED50 in study RES Exposure',NULL,NULL,'2007-03-21 11:01:39'),(105,2,NULL,36,'StudyParameter','Create','Fit Report',' Create parameter Fit Report in study RES Exposure',NULL,NULL,'2007-03-21 11:02:46'),(106,2,NULL,36,'StudyParameter','Update','Fit Report',' Update parameter Fit Report in study RES Exposure',NULL,NULL,'2007-03-21 11:02:46'),(107,2,NULL,37,'StudyParameter','Create','Mean Activity Count',' Create parameter Mean Activity Count in study RES Exposure',NULL,NULL,'2007-03-21 11:16:13'),(108,2,NULL,37,'StudyParameter','Update','Mean Activity Count',' Update parameter Mean Activity Count in study RES Exposure',NULL,NULL,'2007-03-21 11:16:13'),(109,2,NULL,12,'StudyProtocol','Create','Brain Plasma Assessment',' Create protocol Brain Plasma Assessment in study RES Exposure',NULL,NULL,'2007-03-21 11:21:53'),(110,2,NULL,12,'StudyProtocol','Update','Brain Plasma Assessment',' Update protocol Brain Plasma Assessment in study RES Exposure',NULL,NULL,'2007-03-21 11:21:54'),(111,2,NULL,38,'StudyParameter','Create','Gender',' Create parameter Gender in study RES Exposure',NULL,NULL,'2007-03-21 11:23:54'),(112,2,NULL,38,'StudyParameter','Update','Gender',' Update parameter Gender in study RES Exposure',NULL,NULL,'2007-03-21 11:23:54'),(113,2,NULL,39,'StudyParameter','Create','Dose',' Create parameter Dose in study RES Exposure',NULL,NULL,'2007-03-21 11:24:41'),(114,2,NULL,39,'StudyParameter','Update','Dose',' Update parameter Dose in study RES Exposure',NULL,NULL,'2007-03-21 11:24:41'),(115,2,NULL,40,'StudyParameter','Create','TimeAfterDosing',' Create parameter TimeAfterDosing in study RES Exposure',NULL,NULL,'2007-03-21 11:27:51'),(116,2,NULL,40,'StudyParameter','Update','TimeAfterDosing',' Update parameter TimeAfterDosing in study RES Exposure',NULL,NULL,'2007-03-21 11:27:51'),(117,2,NULL,41,'StudyParameter','Create','Plasma Conc',' Create parameter Plasma Conc in study RES Exposure',NULL,NULL,'2007-03-21 11:29:20'),(118,2,NULL,41,'StudyParameter','Update','Plasma Conc',' Update parameter Plasma Conc in study RES Exposure',NULL,NULL,'2007-03-21 11:29:20'),(119,2,NULL,42,'StudyParameter','Create','Brain Conc',' Create parameter Brain Conc in study RES Exposure',NULL,NULL,'2007-03-21 11:29:45'),(120,2,NULL,42,'StudyParameter','Update','Brain Conc',' Update parameter Brain Conc in study RES Exposure',NULL,NULL,'2007-03-21 11:29:45'),(121,2,NULL,43,'StudyParameter','Create','B/P',' Create parameter B/P in study RES Exposure',NULL,NULL,'2007-03-21 11:31:39'),(122,2,NULL,43,'StudyParameter','Update','B/P',' Update parameter B/P in study RES Exposure',NULL,NULL,'2007-03-21 11:31:39'),(123,2,NULL,44,'StudyParameter','Create','Route of Administration',' Create parameter Route of Administration in study RES Exposure',NULL,NULL,'2007-03-21 11:32:13'),(124,2,NULL,44,'StudyParameter','Update','Route of Administration',' Update parameter Route of Administration in study RES Exposure',NULL,NULL,'2007-03-21 11:32:13'),(125,2,NULL,42,'StudyParameter','Update','Brain Conc',' Update parameter Brain Conc in study RES Exposure',NULL,NULL,'2007-03-21 11:40:42'),(126,2,NULL,40,'StudyParameter','Update','TimeAfterDosing',' Update parameter TimeAfterDosing in study RES Exposure',NULL,NULL,'2007-03-21 11:41:14'),(127,3,NULL,3,'Study','Create','Screen',' Create study Screen',NULL,NULL,'2007-03-21 12:49:02'),(128,1,NULL,1,'Experiment','Create','TE-AB001',' Create experiment TE-AB001 in study Biomarker And Histology',NULL,NULL,'2007-03-21 12:54:21'),(129,1,NULL,1,'StudyProtocol','Update','Materials',' Update protocol Materials in study Biomarker And Histology',NULL,NULL,'2007-03-21 14:27:23'),(130,2,NULL,2,'Experiment','Create','TH210307-1',' Create experiment TH210307-1 in study RES Exposure',NULL,NULL,'2007-03-21 14:51:47'),(131,2,NULL,3,'Experiment','Create','TH210307-1',' Create experiment TH210307-1 in study RES Exposure',NULL,NULL,'2007-03-21 15:08:03');
/*!40000 ALTER TABLE `study_logs` ENABLE KEYS */;

--
-- Table structure for table `study_parameters`
--

DROP TABLE IF EXISTS `study_parameters`;
CREATE TABLE `study_parameters` (
  `id` int(11) NOT NULL auto_increment,
  `parameter_type_id` int(11) default NULL,
  `parameter_role_id` int(11) default NULL,
  `study_id` int(11) default '1',
  `name` varchar(255) default NULL,
  `default_value` varchar(255) default NULL,
  `data_element_id` int(11) default NULL,
  `data_type_id` int(11) default NULL,
  `data_format_id` int(11) default NULL,
  `description` varchar(1024) NOT NULL default '',
  `display_unit` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `study_parameters_study_id_index` (`study_id`),
  KEY `study_parameters_default_name_index` (`name`),
  KEY `study_parameters_parameter_type_id_index` (`parameter_type_id`),
  KEY `study_parameters_parameter_role_id_index` (`parameter_role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `study_parameters`
--


/*!40000 ALTER TABLE `study_parameters` DISABLE KEYS */;
INSERT INTO `study_parameters` VALUES (1,20,1,1,'Score','',77,5,NULL,'Manual scoring of samples between 0 &amp; 10',''),(2,7,1,1,'Weight','',NULL,2,4,'','g'),(3,3,1,1,'Reading','',NULL,2,4,'',''),(4,4,2,1,'p','',NULL,2,4,'',''),(5,18,2,1,'sig','',83,5,NULL,'',''),(6,19,3,1,'Treatment Role','',76,5,NULL,'',''),(7,5,3,1,'Index','',NULL,2,8,'',''),(8,1,3,1,'Treatment Group','',NULL,1,1,'',''),(9,12,6,1,'Group Size','10',NULL,2,8,'',''),(10,1,3,1,'Gene','',NULL,1,1,'',''),(11,7,6,1,'Molecular Mass','',NULL,2,4,'',''),(12,7,3,1,'Min Weight','200',NULL,2,4,'','g'),(13,7,3,1,'Min Age','40',NULL,2,8,'','d'),(14,1,6,1,'Molecula Formula','',NULL,1,1,'',''),(15,23,4,1,'Compound','',1,5,NULL,'',''),(18,7,6,1,'Age','',NULL,2,8,'Animal age in days','d'),(19,17,3,1,'Species','rat',63,5,NULL,'',''),(20,7,6,1,'Day','',NULL,2,8,'',''),(21,1,3,1,'ID','',NULL,1,1,'',''),(22,1,3,1,'Strain','ADH',NULL,1,1,'',''),(23,14,2,1,'Calculation','',NULL,2,4,'',''),(24,4,2,1,'Statistic','',NULL,2,4,'',''),(25,18,2,1,'Histology','',84,5,NULL,'Progression flags',''),(26,5,3,2,'Index','',NULL,2,8,'Animal number, index for tables etc',''),(27,22,6,2,'Time','',NULL,4,20,'Start time etc',''),(28,6,1,2,'ActivityCount','',NULL,2,8,'Used for activity counts',''),(29,23,4,2,'Compound','',1,5,NULL,'Compound Under Investigation',''),(30,1,6,2,'Label','',NULL,1,1,'Used for names to identify groups etc',''),(31,19,6,2,'Treatment Role','',76,5,NULL,'Simplifies the identification of the different treatment groups',''),(32,9,6,2,'Concentration','',NULL,2,4,'Concentration of compound under investigation','mg'),(33,12,3,2,'Group Size','8',NULL,2,4,'',''),(34,3,2,2,'Inhibition','',NULL,2,12,'','%'),(35,8,2,2,'ED50','',NULL,2,4,'','mg'),(36,13,2,2,'Fit Report','',NULL,6,24,'A full statistical report of fits',''),(37,4,2,2,'Mean Activity Count','',NULL,2,4,'',''),(38,15,6,2,'Gender','',57,5,NULL,'sex of rat',''),(39,10,6,2,'Dose','',NULL,2,4,'Dosage','mg/kg'),(40,7,6,2,'TimeAfterDosing','1.5',NULL,2,4,'IF actual time i considerably different from the nominal time please enter the actuak time after dosing','h'),(41,9,2,2,'Plasma Conc','',NULL,2,4,'','ng/mL'),(42,9,2,2,'Brain Conc','',NULL,2,4,'','ng/g'),(43,7,2,2,'B/P','',NULL,2,4,'Brain concentration (ng/g) : Plasma Concentration (ng/mL)',''),(44,16,6,2,'Route of Administration','sc',56,5,NULL,'','');
/*!40000 ALTER TABLE `study_parameters` ENABLE KEYS */;

--
-- Table structure for table `study_protocols`
--

DROP TABLE IF EXISTS `study_protocols`;
CREATE TABLE `study_protocols` (
  `id` int(11) NOT NULL auto_increment,
  `study_id` int(11) NOT NULL,
  `study_stage_id` int(11) NOT NULL default '1',
  `current_process_id` int(11) default NULL,
  `process_definition_id` int(11) default NULL,
  `process_style` varchar(128) NOT NULL default 'Entry',
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `literature_ref` text,
  `protocol_catagory` varchar(20) default NULL,
  `protocol_status` varchar(20) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `study_protocols_study_id_index` (`study_id`),
  KEY `study_protocols_process_instance_id_index` (`current_process_id`),
  KEY `study_protocols_process_definition_id_index` (`process_definition_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `study_protocols`
--


/*!40000 ALTER TABLE `study_protocols` DISABLE KEYS */;
INSERT INTO `study_protocols` VALUES (1,1,5,1,NULL,'Entry','Materials','Define the materials used in this study, both those for investigation, the vehicle, controls etc','','Web','',2,'','2007-03-20 19:50:48','','2007-03-21 14:27:23'),(2,1,5,2,NULL,'Entry','Animals','Assign animals to treatment groups, recording their age and weight.  Animals should be over 40 days old and weigh 200g','','Spreadsheet','',1,'','2007-03-20 20:05:26','','2007-03-20 20:05:26'),(3,1,5,3,NULL,'Entry','Treatments','Treatment group definition','','Web','',1,'','2007-03-20 20:09:03','','2007-03-20 20:09:03'),(4,1,6,4,NULL,'Entry','Weights','Track the weights of the individual animals over a number of days','','Spreadsheet','',2,'','2007-03-20 20:54:26','','2007-03-20 20:55:11'),(5,1,8,5,NULL,'Entry','Weight Summary','Plot mean and SD for each treatment group','','Spreadsheet','',1,'','2007-03-20 21:00:33','','2007-03-20 21:00:33'),(6,1,6,6,NULL,'Entry','Taqman Readings','Gene expression reading','','Spreadsheet','',3,'','2007-03-20 21:15:22','','2007-03-20 21:20:28'),(7,1,8,7,NULL,'Entry','Taqman Analysis','Run statistical analysis over Taqman readings and generate probability scores.  Progress Groups that are significantly different from control to histological analysis ','','Web','',1,'','2007-03-20 21:22:37','','2007-03-20 21:22:37'),(8,1,6,8,NULL,'Entry','Histological Scoring','Score lung slices for symptoms','','Web','',1,'','2007-03-20 21:31:18','','2007-03-20 21:31:18'),(9,2,5,9,NULL,'Entry','Setup Materials and Groups','Preparation step where the investigator defines the materials under investigation and the size of the treatment groups','','Web','',1,'','2007-03-21 09:51:33','','2007-03-21 09:51:33'),(10,2,6,10,NULL,'Entry','Capture Raw Data','Capture raw data (ActivityCounts) into system and generate some basic statistics.','','Spreadsheet','',1,'','2007-03-21 10:07:13','','2007-03-21 10:07:13'),(11,2,8,11,NULL,'Entry','ED50 Calculation','Take raw data, normalise it and generate an ED50','','Spreadsheet','',1,'','2007-03-21 10:32:26','','2007-03-21 10:32:26'),(12,2,5,12,NULL,'Entry','Brain Plasma Assessment','Plasma samples\r\nThe plasma samples should be taken into K3EDTA tubes and centrifuged at 10-15 min. at 2000 G (5Â°C)\r\nStore the samples in polypropylene tubes (order no.M32022, Micronic, In vitro A/S)\r\nThe tubes should be closed with a break-off capband (order no. M82605, Miconic, In Vitro A/S)\r\nA minimum of 200 ÂµL plasma is required\r\nPlace the samples systematically in a rack (order no. M22504, Micronic, In Vitro A/S)\r\n\r\nBrain samples\r\nWhole brain samples should be weigh out and stored in 12 mL tubes from VWR International (Article No. BDAA352059)\r\nFor mice the whole brain should be used and for rats Â½ brain should be used \r\nThe brains should be weighed out and taken down at this sampleinfo\r\nLabel all tubes with labels from Cils (40 x17 mm, cat.no. E45-A8735), please ask for the wordtemplate\r\nALL samples should be labelled with information of study no., dose, group no., time (nominel) and compound no.\r\nStore the samples at -80Â°C\r\n\r\nIf actual time is considerable different from nominel time please write the actual time after dosing  \r\nplease send this infosheet to the mailbox: exposure\r\n','','Protocol','',1,'','2007-03-21 11:21:53','','2007-03-21 11:21:54');
/*!40000 ALTER TABLE `study_protocols` ENABLE KEYS */;

--
-- Table structure for table `study_queues`
--

DROP TABLE IF EXISTS `study_queues`;
CREATE TABLE `study_queues` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `study_id` int(11) default NULL,
  `study_stage_id` int(11) default NULL,
  `study_parameter_id` int(11) default NULL,
  `study_protocol_id` int(11) default NULL,
  `assigned_to` varchar(60) default NULL,
  `status` varchar(255) NOT NULL default 'new',
  `priority` varchar(255) NOT NULL default 'normal',
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `study_queues`
--


/*!40000 ALTER TABLE `study_queues` DISABLE KEYS */;
INSERT INTO `study_queues` VALUES (6,'Weight_Impact','Assessment of the impact of compound on the change of weight of animals.&nbsp; Can vary route of administration, sex and species.',14,5,166,41,'thawkins','New','Low',1,'','2007-01-31 16:33:14','','2007-01-31 16:33:14'),(7,'Screening','Full screen against the compound library.  Please define the Target.  The service will include the development of the assay, full screen at single point, a confirmation assay of the initial hits and an EX50 determination of any hits.',15,6,175,52,'alemon','New','Low',2,'','2007-01-31 16:39:19','','2007-02-08 14:08:59'),(8,'Dose Response','Run a dose response experiment against a defined assay for a list of compound ids (hits)',15,8,175,NULL,'alemon','New','High',1,'','2007-01-31 16:40:25','','2007-01-31 16:40:25'),(9,'Structure Elucidation','Determine the structure of a sample',18,8,177,NULL,'rshell','New','High',1,'','2007-01-31 16:44:07','','2007-01-31 16:44:07'),(10,'Structure Confirmation','Confirm suggested structure',18,5,177,NULL,'rshell','New','Low',1,'','2007-01-31 16:44:44','','2007-01-31 16:44:44'),(11,'Purity','Determination of sample purity',18,5,177,NULL,'alemon','New','Normal',1,'','2007-01-31 16:45:15','','2007-01-31 16:45:15'),(12,'B&H Study','A full run of the BioMarker and histology study',17,5,212,NULL,'2','new','normal',3,'','2007-03-08 07:14:00','','2007-03-08 07:22:23'),(13,'Taqman Analysis','Taqman readings of surviving animals',17,6,217,NULL,'2','new','normal',1,'','2007-03-08 07:17:46','','2007-03-08 07:17:46'),(14,'Histological Analysis','Good look at the internal organs',17,6,229,NULL,'2','new','normal',1,'','2007-03-08 07:19:50','','2007-03-08 07:19:50'),(15,'Submit Compound','Submit a compound for testing',1,5,15,NULL,'4','new','normal',1,'','2007-03-20 18:59:39','','2007-03-20 18:59:39'),(16,'Animal for Taqman','Submit animal ID for Taqman gene expression analysis',1,6,21,NULL,'2','new','normal',4,'','2007-03-20 19:00:57','','2007-03-21 13:11:36'),(17,'Group for Histology','Provide animal identifier for histological analysis',1,6,8,NULL,'6','new','normal',2,'','2007-03-20 20:00:33','','2007-03-20 21:34:02'),(18,'RES Exposure Service','Please submit one or more compounds to this service.&nbsp; Turn around time is c. 1 week.',2,6,29,NULL,'4','new','normal',1,'','2007-03-21 09:49:14','','2007-03-21 09:49:14');
/*!40000 ALTER TABLE `study_queues` ENABLE KEYS */;

--
-- Table structure for table `study_stages`
--

DROP TABLE IF EXISTS `study_stages`;
CREATE TABLE `study_stages` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `study_stages`
--


/*!40000 ALTER TABLE `study_stages` DISABLE KEYS */;
INSERT INTO `study_stages` VALUES (5,'Preparation','Preparation steps',0,'','2006-12-11 18:32:33','','2006-12-11 18:32:33'),(6,'Data Capture','Capturing raw data',0,'','2006-12-11 18:32:56','','2006-12-11 18:32:56'),(8,'Analysis','Data analysis',0,'','2006-12-11 18:33:23','','2006-12-11 18:33:23');
/*!40000 ALTER TABLE `study_stages` ENABLE KEYS */;

--
-- Temporary table structure for view `study_statistics`
--

DROP TABLE IF EXISTS `study_statistics`;
/*!50001 DROP VIEW IF EXISTS `study_statistics`*/;
/*!50001 CREATE TABLE `study_statistics` (
  `id` int(11),
  `study_id` int(11),
  `parameter_role_id` int(11),
  `parameter_type_id` int(11),
  `data_type_id` int(11),
  `avg_values` double,
  `stddev_values` double,
  `num_values` bigint(20),
  `num_unique` bigint(20),
  `max_values` double,
  `min_values` double
) */;

--
-- Table structure for table `system_settings`
--

DROP TABLE IF EXISTS `system_settings`;
CREATE TABLE `system_settings` (
  `id` int(11) NOT NULL auto_increment,
  `site_name` varchar(255) NOT NULL,
  `site_subtitle` varchar(255) default NULL,
  `footer_message` varchar(255) default '',
  `public_role_id` int(11) NOT NULL default '0',
  `session_timeout` int(11) NOT NULL default '0',
  `default_markup_style_id` int(11) default '0',
  `site_default_page_id` int(11) NOT NULL default '0',
  `not_found_page_id` int(11) NOT NULL default '0',
  `permission_denied_page_id` int(11) NOT NULL default '0',
  `session_expired_page_id` int(11) NOT NULL default '0',
  `menu_depth` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `fk_system_settings_public_role_id` (`public_role_id`),
  KEY `fk_system_settings_site_default_page_id` (`site_default_page_id`),
  KEY `fk_system_settings_not_found_page_id` (`not_found_page_id`),
  KEY `fk_system_settings_permission_denied_page_id` (`permission_denied_page_id`),
  KEY `fk_system_settings_session_expired_page_id` (`session_expired_page_id`),
  CONSTRAINT `fk_system_settings_not_found_page_id` FOREIGN KEY (`not_found_page_id`) REFERENCES `content_pages` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_system_settings_permission_denied_page_id` FOREIGN KEY (`permission_denied_page_id`) REFERENCES `content_pages` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_system_settings_public_role_id` FOREIGN KEY (`public_role_id`) REFERENCES `roles` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_system_settings_session_expired_page_id` FOREIGN KEY (`session_expired_page_id`) REFERENCES `content_pages` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_system_settings_site_default_page_id` FOREIGN KEY (`site_default_page_id`) REFERENCES `content_pages` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `system_settings`
--


/*!40000 ALTER TABLE `system_settings` DISABLE KEYS */;
INSERT INTO `system_settings` VALUES (1,'BioRails','Next generation of biological management','Site developed by <a href=\"http://www.edgesoftwareconsultancy.com\">The Edge</a>',1,7200,1,1,3,4,2,3);
/*!40000 ALTER TABLE `system_settings` ENABLE KEYS */;

--
-- Table structure for table `task_contexts`
--

DROP TABLE IF EXISTS `task_contexts`;
CREATE TABLE `task_contexts` (
  `id` int(11) NOT NULL auto_increment,
  `task_id` int(11) default NULL,
  `parameter_context_id` int(11) default NULL,
  `label` varchar(255) default NULL,
  `is_valid` tinyint(1) default NULL,
  `row_no` int(11) NOT NULL,
  `parent_id` int(11) default NULL,
  `sequence_no` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `task_contexts_task_id_index` (`task_id`),
  KEY `task_contexts_parameter_context_id_index` (`parameter_context_id`),
  KEY `task_contexts_row_no_index` (`row_no`),
  KEY `task_contexts_label_index` (`label`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `task_contexts`
--


/*!40000 ALTER TABLE `task_contexts` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_contexts` ENABLE KEYS */;

--
-- Table structure for table `task_files`
--

DROP TABLE IF EXISTS `task_files`;
CREATE TABLE `task_files` (
  `id` int(11) NOT NULL auto_increment,
  `task_context_id` int(11) default NULL,
  `parameter_id` int(11) default NULL,
  `data_uri` varchar(255) default NULL,
  `is_external` tinyint(1) default NULL,
  `mime_type` varchar(250) default NULL,
  `data_binary` text,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `task_id` int(11) default NULL,
  `content_type` varchar(255) default NULL,
  `parent_id` int(11) default NULL,
  `filename` varchar(255) default NULL,
  `thumbnail` varchar(255) default NULL,
  `size` int(11) default NULL,
  `width` int(11) default NULL,
  `height` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `task_files`
--


/*!40000 ALTER TABLE `task_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_files` ENABLE KEYS */;

--
-- Table structure for table `task_references`
--

DROP TABLE IF EXISTS `task_references`;
CREATE TABLE `task_references` (
  `id` int(11) NOT NULL auto_increment,
  `task_context_id` int(11) default NULL,
  `parameter_id` int(11) default NULL,
  `data_element_id` int(11) default NULL,
  `data_type` varchar(255) default NULL,
  `data_id` int(11) default NULL,
  `data_name` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `task_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `task_references_task_id_index` (`task_id`),
  KEY `task_references_task_context_id_index` (`task_context_id`),
  KEY `task_references_parameter_id_index` (`parameter_id`),
  KEY `task_references_updated_at_index` (`updated_at`),
  KEY `task_references_updated_by_index` (`updated_by`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `task_references`
--


/*!40000 ALTER TABLE `task_references` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_references` ENABLE KEYS */;

--
-- Table structure for table `task_relations`
--

DROP TABLE IF EXISTS `task_relations`;
CREATE TABLE `task_relations` (
  `id` int(11) NOT NULL auto_increment,
  `to_task_id` int(11) default NULL,
  `from_task_id` int(11) default NULL,
  `relation_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `task_relations`
--


/*!40000 ALTER TABLE `task_relations` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_relations` ENABLE KEYS */;

--
-- Temporary table structure for view `task_result_texts`
--

DROP TABLE IF EXISTS `task_result_texts`;
/*!50001 DROP VIEW IF EXISTS `task_result_texts`*/;
/*!50001 CREATE TABLE `task_result_texts` (
  `id` int(11),
  `row_no` int(11),
  `column_no` int(11),
  `task_id` int(11),
  `parameter_context_id` int(11),
  `task_context_id` int(11),
  `reference_parameter_id` int(11),
  `data_element_id` int(11),
  `data_type` varchar(255),
  `data_id` int(11),
  `subject` varchar(255),
  `parameter_id` int(11),
  `protocol_version_id` int(11),
  `label` varchar(255),
  `row_label` varchar(255),
  `parameter_name` varchar(62),
  `data_value` text,
  `created_by` varchar(32),
  `created_at` datetime,
  `updated_by` varchar(32),
  `updated_at` datetime
) */;

--
-- Temporary table structure for view `task_result_values`
--

DROP TABLE IF EXISTS `task_result_values`;
/*!50001 DROP VIEW IF EXISTS `task_result_values`*/;
/*!50001 CREATE TABLE `task_result_values` (
  `id` int(11),
  `row_no` int(11),
  `column_no` int(11),
  `task_id` int(11),
  `parameter_context_id` int(11),
  `task_context_id` int(11),
  `reference_parameter_id` int(11),
  `data_element_id` int(11),
  `data_type` varchar(255),
  `data_id` int(11),
  `subject` varchar(255),
  `parameter_id` int(11),
  `protocol_version_id` int(11),
  `label` varchar(255),
  `row_label` varchar(255),
  `parameter_name` varchar(62),
  `data_value` double,
  `created_by` varchar(32),
  `created_at` datetime,
  `updated_by` varchar(32),
  `updated_at` datetime
) */;

--
-- Temporary table structure for view `task_results`
--

DROP TABLE IF EXISTS `task_results`;
/*!50001 DROP VIEW IF EXISTS `task_results`*/;
/*!50001 CREATE TABLE `task_results` (
  `id` int(11),
  `protocol_version_id` int(11),
  `parameter_context_id` int(11),
  `label` varchar(255),
  `row_label` varchar(255),
  `row_no` int(11),
  `column_no` int(11),
  `task_id` int(11),
  `parameter_id` int(11),
  `parameter_name` varchar(62),
  `data_value` longblob,
  `created_by` varchar(32),
  `created_at` datetime,
  `updated_by` varchar(32),
  `updated_at` datetime
) */;

--
-- Temporary table structure for view `task_statistics`
--

DROP TABLE IF EXISTS `task_statistics`;
/*!50001 DROP VIEW IF EXISTS `task_statistics`*/;
/*!50001 CREATE TABLE `task_statistics` (
  `id` bigint(20),
  `task_id` int(11),
  `parameter_id` int(11),
  `parameter_role_id` int(11),
  `parameter_type_id` int(11),
  `data_type_id` int(11),
  `avg_values` double,
  `stddev_values` double,
  `num_values` bigint(20),
  `num_unique` bigint(20),
  `max_values` longblob,
  `min_values` longblob
) */;

--
-- Temporary table structure for view `task_stats1`
--

DROP TABLE IF EXISTS `task_stats1`;
/*!50001 DROP VIEW IF EXISTS `task_stats1`*/;
/*!50001 CREATE TABLE `task_stats1` (
  `task_id` int(11),
  `parameter_role_id` int(11),
  `parameter_type_id` int(11),
  `data_type_id` int(11),
  `avg_values` double,
  `stddev_values` double,
  `num_values` bigint(20),
  `num_unique` bigint(20),
  `max_values` double,
  `min_values` double
) */;

--
-- Temporary table structure for view `task_stats2`
--

DROP TABLE IF EXISTS `task_stats2`;
/*!50001 DROP VIEW IF EXISTS `task_stats2`*/;
/*!50001 CREATE TABLE `task_stats2` (
  `task_id` int(11),
  `parameter_id` int(11),
  `avg_values` double,
  `stddev_values` double,
  `num_values` bigint(20),
  `num_unique` bigint(20),
  `max_values` double,
  `min_values` double
) */;

--
-- Table structure for table `task_texts`
--

DROP TABLE IF EXISTS `task_texts`;
CREATE TABLE `task_texts` (
  `id` int(11) NOT NULL auto_increment,
  `task_context_id` int(11) default NULL,
  `parameter_id` int(11) default NULL,
  `markup_style_id` int(11) default NULL,
  `data_content` text,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `task_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `task_texts_task_id_index` (`task_id`),
  KEY `task_texts_task_context_id_index` (`task_context_id`),
  KEY `task_texts_parameter_id_index` (`parameter_id`),
  KEY `task_texts_updated_at_index` (`updated_at`),
  KEY `task_texts_updated_by_index` (`updated_by`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `task_texts`
--


/*!40000 ALTER TABLE `task_texts` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_texts` ENABLE KEYS */;

--
-- Table structure for table `task_values`
--

DROP TABLE IF EXISTS `task_values`;
CREATE TABLE `task_values` (
  `id` int(11) NOT NULL auto_increment,
  `task_context_id` int(11) default NULL,
  `parameter_id` int(11) default NULL,
  `data_value` double default NULL,
  `display_unit` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `task_id` int(11) default NULL,
  `storage_unit` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `task_values_task_id_index` (`task_id`),
  KEY `task_values_task_context_id_index` (`task_context_id`),
  KEY `task_values_parameter_id_index` (`parameter_id`),
  KEY `task_values_updated_at_index` (`updated_at`),
  KEY `task_values_updated_by_index` (`updated_by`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `task_values`
--


/*!40000 ALTER TABLE `task_values` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_values` ENABLE KEYS */;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
CREATE TABLE `tasks` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `experiment_id` int(11) default NULL,
  `protocol_version_id` int(11) default NULL,
  `status_id` int(11) default NULL,
  `is_milestone` tinyint(1) default NULL,
  `assigned_to` varchar(60) default NULL,
  `priority_id` int(11) default NULL,
  `start_date` datetime default NULL,
  `end_date` datetime default NULL,
  `expected_hours` double default NULL,
  `done_hours` double default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  `study_protocol_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `tasks_name_index` (`name`),
  KEY `tasks_experiment_id_index` (`experiment_id`),
  KEY `tasks_process_instance_id_index` (`protocol_version_id`),
  KEY `tasks_study_protocol_id_index` (`study_protocol_id`),
  KEY `tasks_start_date_index` (`start_date`),
  KEY `tasks_end_date_index` (`end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tasks`
--


/*!40000 ALTER TABLE `tasks` DISABLE KEYS */;
/*!40000 ALTER TABLE `tasks` ENABLE KEYS */;

--
-- Table structure for table `tmp_data`
--

DROP TABLE IF EXISTS `tmp_data`;
CREATE TABLE `tmp_data` (
  `id` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tmp_data`
--


/*!40000 ALTER TABLE `tmp_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `tmp_data` ENABLE KEYS */;

--
-- Table structure for table `treatment_groups`
--

DROP TABLE IF EXISTS `treatment_groups`;
CREATE TABLE `treatment_groups` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(128) NOT NULL default '',
  `description` text,
  `study_id` int(11) default NULL,
  `experiment_id` int(11) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `treatment_groups`
--


/*!40000 ALTER TABLE `treatment_groups` DISABLE KEYS */;
INSERT INTO `treatment_groups` VALUES (1,'GroupA','Grtopu',NULL,NULL,0,'','2006-12-18 22:44:04','','2006-12-18 22:44:04'),(2,'GroupB','B',NULL,NULL,0,'','2006-12-18 22:44:22','','2006-12-18 22:44:22');
/*!40000 ALTER TABLE `treatment_groups` ENABLE KEYS */;

--
-- Table structure for table `treatment_items`
--

DROP TABLE IF EXISTS `treatment_items`;
CREATE TABLE `treatment_items` (
  `id` int(11) NOT NULL auto_increment,
  `treatment_group_id` int(11) NOT NULL,
  `subject_type` varchar(255) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `sequence_order` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `treatment_items`
--


/*!40000 ALTER TABLE `treatment_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `treatment_items` ENABLE KEYS */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `password` varchar(40) NOT NULL,
  `role_id` int(11) NOT NULL,
  `password_salt` varchar(255) default NULL,
  `fullname` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_user_role_id` (`role_id`),
  CONSTRAINT `fk_user_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--


/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (2,'admin','d033e22ae348aeb5660fc2140aec35850c4da997',3,NULL,NULL,NULL),(3,'rshell','66549d85d66747b93596bd7b05409f544ef97310',3,NULL,NULL,NULL),(4,'thawkins','d84e5ddda8a7eef03dd5e4934ede87d1a1758a96',3,NULL,NULL,NULL),(5,'ANother','cebc21d4c7bcef9624474cda20ebb609e4c2779f',2,NULL,NULL,NULL),(6,'alemon','773418797bbc217fa520ba98f090227cd0b74b18',3,NULL,NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;

--
-- Temporary table structure for view `view_controller_actions`
--

DROP TABLE IF EXISTS `view_controller_actions`;
/*!50001 DROP VIEW IF EXISTS `view_controller_actions`*/;
/*!50001 CREATE TABLE `view_controller_actions` (
  `id` int(11),
  `site_controller_id` int(11),
  `site_controller_name` varchar(255),
  `name` varchar(255),
  `permission_id` bigint(11)
) */;

--
-- Temporary table structure for view `view_menu_items`
--

DROP TABLE IF EXISTS `view_menu_items`;
/*!50001 DROP VIEW IF EXISTS `view_menu_items`*/;
/*!50001 CREATE TABLE `view_menu_items` (
  `menu_item_id` bigint(11) unsigned,
  `menu_item_name` varchar(255),
  `menu_item_label` varchar(255),
  `menu_item_seq` int(11),
  `menu_item_parent_id` int(11),
  `site_controller_id` int(11),
  `site_controller_name` varchar(255),
  `controller_action_id` int(11),
  `controller_action_name` varchar(255),
  `content_page_id` int(11),
  `content_page_name` varchar(255),
  `content_page_title` varchar(255),
  `permission_id` int(11),
  `permission_name` varchar(255)
) */;

--
-- Table structure for table `work_status`
--

DROP TABLE IF EXISTS `work_status`;
CREATE TABLE `work_status` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `lock_version` int(11) NOT NULL default '0',
  `created_by` varchar(32) NOT NULL default '',
  `created_at` datetime NOT NULL,
  `updated_by` varchar(32) NOT NULL default '',
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `work_status`
--


/*!40000 ALTER TABLE `work_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `work_status` ENABLE KEYS */;

--
-- Final view structure for view `compound_results`
--

/*!50001 DROP TABLE IF EXISTS `compound_results`*/;
/*!50001 DROP VIEW IF EXISTS `compound_results`*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`biorails`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `compound_results` AS select `ti`.`id` AS `id`,`tc`.`row_no` AS `row_no`,`p`.`column_no` AS `column_no`,`tc`.`task_id` AS `task_id`,`p`.`parameter_context_id` AS `parameter_context_id`,`tr`.`task_context_id` AS `task_context_id`,`tr`.`data_element_id` AS `data_element_id`,`tr`.`parameter_id` AS `compound_parameter_id`,`tr`.`data_id` AS `compound_id`,`tr`.`data_name` AS `compound_name`,`pc`.`protocol_version_id` AS `protocol_version_id`,`pc`.`label` AS `label`,`tc`.`label` AS `row_label`,`ti`.`parameter_id` AS `parameter_id`,`p`.`name` AS `parameter_name`,`ti`.`data_value` AS `data_value`,`ti`.`created_by` AS `created_by`,`ti`.`created_at` AS `created_at`,`ti`.`updated_by` AS `updated_by`,`ti`.`updated_at` AS `updated_at` from ((((`parameter_contexts` `pc` join `parameters` `p`) join `task_contexts` `tc`) join `task_references` `tr`) join `task_values` `ti`) where ((`tc`.`id` = `tr`.`task_context_id`) and (`ti`.`task_context_id` = `tc`.`id`) and (`p`.`id` = `ti`.`parameter_id`) and (`pc`.`id` = `tc`.`parameter_context_id`) and (`tr`.`data_type` = _latin1'Compound')) */;

--
-- Final view structure for view `experiment_statistics`
--

/*!50001 DROP TABLE IF EXISTS `experiment_statistics`*/;
/*!50001 DROP VIEW IF EXISTS `experiment_statistics`*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`biorails`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `experiment_statistics` AS select ((`t`.`experiment_id` * 1000000) + `p`.`study_parameter_id`) AS `id`,`t`.`experiment_id` AS `experiment_id`,`p`.`study_parameter_id` AS `study_parameter_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,`p`.`data_type_id` AS `data_type_id`,avg(`r`.`data_value`) AS `avg_values`,std(`r`.`data_value`) AS `stddev_values`,count(`r`.`data_value`) AS `num_values`,count(distinct `r`.`data_value`) AS `num_unique`,max(`r`.`data_value`) AS `max_values`,min(`r`.`data_value`) AS `min_values` from ((`task_values` `r` join `parameters` `p`) join `tasks` `t`) where ((`p`.`id` = `r`.`parameter_id`) and (`t`.`id` = `r`.`task_id`) and (`p`.`study_parameter_id` is not null)) group by `t`.`experiment_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`data_type_id`,`p`.`study_parameter_id` union select ((`t`.`experiment_id` * 1000000) + `p`.`study_parameter_id`) AS `id`,`t`.`experiment_id` AS `experiment_id`,`p`.`study_parameter_id` AS `study_parameter_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,`p`.`data_type_id` AS `data_type_id`,sum(NULL) AS `avg_values`,sum(NULL) AS `stddev_values`,count(`r`.`id`) AS `num_values`,count(distinct `r`.`data_content`) AS `num_unique`,sum(NULL) AS `max_values`,sum(NULL) AS `min_values` from ((`task_texts` `r` join `parameters` `p`) join `tasks` `t`) where ((`p`.`id` = `r`.`parameter_id`) and (`p`.`study_parameter_id` is not null) and (`t`.`id` = `r`.`task_id`)) group by `t`.`experiment_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`data_type_id`,`p`.`study_parameter_id` union select ((`t`.`experiment_id` * 1000000) + `p`.`study_parameter_id`) AS `id`,`t`.`experiment_id` AS `experiment_id`,`p`.`study_parameter_id` AS `study_parameter_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,`p`.`data_type_id` AS `data_type_id`,sum(NULL) AS `avg_values`,sum(NULL) AS `stddev_values`,count(`r`.`id`) AS `num_values`,count(distinct `r`.`data_name`) AS `num_unique`,max(`r`.`data_id`) AS `max_values`,min(`r`.`data_id`) AS `min_values` from ((`task_references` `r` join `parameters` `p`) join `tasks` `t`) where ((`p`.`id` = `r`.`parameter_id`) and (`p`.`study_parameter_id` is not null) and (`t`.`id` = `r`.`task_id`)) group by `t`.`experiment_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`data_type_id`,`p`.`study_parameter_id` */;

--
-- Final view structure for view `process_statistics`
--

/*!50001 DROP TABLE IF EXISTS `process_statistics`*/;
/*!50001 DROP VIEW IF EXISTS `process_statistics`*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`biorails`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `process_statistics` AS select `p`.`id` AS `id`,`p`.`study_parameter_id` AS `study_parameter_id`,`p`.`protocol_version_id` AS `protocol_version_id`,`r`.`parameter_id` AS `parameter_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,avg(`r`.`data_value`) AS `avg_values`,std(`r`.`data_value`) AS `stddev_values`,count(`r`.`data_value`) AS `num_values`,count(distinct `r`.`data_value`) AS `num_unique`,max(`r`.`data_value`) AS `max_values`,min(`r`.`data_value`) AS `min_values` from (`task_values` `r` join `parameters` `p`) where (`p`.`id` = `r`.`parameter_id`) group by `p`.`study_parameter_id`,`p`.`protocol_version_id`,`r`.`parameter_id`,`p`.`id` union select `p`.`id` AS `id`,`p`.`study_parameter_id` AS `study_parameter_id`,`p`.`protocol_version_id` AS `protocol_version_id`,`r`.`parameter_id` AS `parameter_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,sum(NULL) AS `avg_values`,sum(NULL) AS `stddev_values`,count(`r`.`id`) AS `num_values`,count(distinct `r`.`data_content`) AS `num_unique`,sum(NULL) AS `max_values`,sum(NULL) AS `min_values` from (`task_texts` `r` join `parameters` `p`) where (`p`.`id` = `r`.`parameter_id`) group by `p`.`study_parameter_id`,`p`.`protocol_version_id`,`r`.`parameter_id`,`p`.`id` union select `p`.`id` AS `id`,`p`.`study_parameter_id` AS `study_parameter_id`,`p`.`protocol_version_id` AS `protocol_version_id`,`r`.`parameter_id` AS `parameter_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,sum(NULL) AS `avg_values`,sum(NULL) AS `stddev_values`,count(`r`.`id`) AS `num_values`,count(distinct `r`.`data_name`) AS `num_unique`,max(`r`.`data_id`) AS `max_values`,min(`r`.`data_id`) AS `min_values` from (`task_references` `r` join `parameters` `p`) where (`p`.`id` = `r`.`parameter_id`) group by `p`.`study_parameter_id`,`p`.`protocol_version_id`,`r`.`parameter_id`,`p`.`id` */;

--
-- Final view structure for view `study_statistics`
--

/*!50001 DROP TABLE IF EXISTS `study_statistics`*/;
/*!50001 DROP VIEW IF EXISTS `study_statistics`*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`biorails`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `study_statistics` AS select `p`.`study_parameter_id` AS `id`,`e`.`study_id` AS `study_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,`p`.`data_type_id` AS `data_type_id`,avg(`r`.`data_value`) AS `avg_values`,std(`r`.`data_value`) AS `stddev_values`,count(`r`.`data_value`) AS `num_values`,count(distinct `r`.`data_value`) AS `num_unique`,max(`r`.`data_value`) AS `max_values`,min(`r`.`data_value`) AS `min_values` from (((`task_values` `r` join `parameters` `p`) join `tasks` `t`) join `experiments` `e`) where ((`p`.`id` = `r`.`parameter_id`) and (`t`.`id` = `r`.`task_id`) and (`e`.`id` = `t`.`experiment_id`) and (`p`.`study_parameter_id` is not null)) group by `e`.`study_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`study_parameter_id` union select `p`.`study_parameter_id` AS `id`,`e`.`study_id` AS `study_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,`p`.`data_type_id` AS `data_type_id`,sum(NULL) AS `avg_values`,sum(NULL) AS `stddev_values`,count(`r`.`id`) AS `num_values`,count(distinct `r`.`data_content`) AS `num_unique`,sum(NULL) AS `max_values`,sum(NULL) AS `min_values` from (((`task_texts` `r` join `parameters` `p`) join `tasks` `t`) join `experiments` `e`) where ((`p`.`id` = `r`.`parameter_id`) and (`t`.`id` = `r`.`task_id`) and (`e`.`id` = `t`.`experiment_id`) and (`p`.`study_parameter_id` is not null)) group by `e`.`study_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`study_parameter_id` union select `p`.`study_parameter_id` AS `id`,`e`.`study_id` AS `study_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,`p`.`data_type_id` AS `data_type_id`,sum(NULL) AS `avg_values`,sum(NULL) AS `stddev_values`,count(`r`.`id`) AS `num_values`,count(distinct `r`.`data_name`) AS `num_unique`,max(`r`.`data_id`) AS `max_values`,min(`r`.`data_id`) AS `min_values` from (((`task_references` `r` join `parameters` `p`) join `tasks` `t`) join `experiments` `e`) where ((`p`.`id` = `r`.`parameter_id`) and (`t`.`id` = `r`.`task_id`) and (`e`.`id` = `t`.`experiment_id`) and (`p`.`study_parameter_id` is not null)) group by `e`.`study_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`study_parameter_id` */;

--
-- Final view structure for view `task_result_texts`
--

/*!50001 DROP TABLE IF EXISTS `task_result_texts`*/;
/*!50001 DROP VIEW IF EXISTS `task_result_texts`*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`biorails`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `task_result_texts` AS select `ti`.`id` AS `id`,`tc`.`row_no` AS `row_no`,`p`.`column_no` AS `column_no`,`tc`.`task_id` AS `task_id`,`p`.`parameter_context_id` AS `parameter_context_id`,`tr`.`task_context_id` AS `task_context_id`,`tr`.`parameter_id` AS `reference_parameter_id`,`tr`.`data_element_id` AS `data_element_id`,`tr`.`data_type` AS `data_type`,`tr`.`data_id` AS `data_id`,`tr`.`data_name` AS `subject`,`ti`.`parameter_id` AS `parameter_id`,`pc`.`protocol_version_id` AS `protocol_version_id`,`pc`.`label` AS `label`,`tc`.`label` AS `row_label`,`p`.`name` AS `parameter_name`,`ti`.`data_content` AS `data_value`,`ti`.`created_by` AS `created_by`,`ti`.`created_at` AS `created_at`,`ti`.`updated_by` AS `updated_by`,`ti`.`updated_at` AS `updated_at` from ((((`parameter_contexts` `pc` join `parameters` `p`) join `task_contexts` `tc`) join `task_references` `tr`) join `task_texts` `ti`) where ((`tc`.`id` = `tr`.`task_context_id`) and (`ti`.`task_context_id` = `tc`.`id`) and (`p`.`id` = `ti`.`parameter_id`) and (`pc`.`id` = `tc`.`parameter_context_id`)) */;

--
-- Final view structure for view `task_result_values`
--

/*!50001 DROP TABLE IF EXISTS `task_result_values`*/;
/*!50001 DROP VIEW IF EXISTS `task_result_values`*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `task_result_values` AS select `ti`.`id` AS `id`,`tc`.`row_no` AS `row_no`,`p`.`column_no` AS `column_no`,`tc`.`task_id` AS `task_id`,`p`.`parameter_context_id` AS `parameter_context_id`,`tr`.`task_context_id` AS `task_context_id`,`tr`.`parameter_id` AS `reference_parameter_id`,`tr`.`data_element_id` AS `data_element_id`,`tr`.`data_type` AS `data_type`,`tr`.`data_id` AS `data_id`,`tr`.`data_name` AS `subject`,`ti`.`parameter_id` AS `parameter_id`,`pc`.`protocol_version_id` AS `protocol_version_id`,`pc`.`label` AS `label`,`tc`.`label` AS `row_label`,`p`.`name` AS `parameter_name`,`ti`.`data_value` AS `data_value`,`ti`.`created_by` AS `created_by`,`ti`.`created_at` AS `created_at`,`ti`.`updated_by` AS `updated_by`,`ti`.`updated_at` AS `updated_at` from ((((`parameter_contexts` `pc` join `parameters` `p`) join `task_contexts` `tc`) join `task_references` `tr`) join `task_values` `ti`) where ((`tc`.`id` = `tr`.`task_context_id`) and (`ti`.`task_context_id` = `tc`.`id`) and (`p`.`id` = `ti`.`parameter_id`) and (`pc`.`id` = `tc`.`parameter_context_id`)) */;

--
-- Final view structure for view `task_results`
--

/*!50001 DROP TABLE IF EXISTS `task_results`*/;
/*!50001 DROP VIEW IF EXISTS `task_results`*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`biorails`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `task_results` AS select `ti`.`id` AS `id`,`pc`.`protocol_version_id` AS `protocol_version_id`,`pc`.`id` AS `parameter_context_id`,`pc`.`label` AS `label`,`tc`.`label` AS `row_label`,`tc`.`row_no` AS `row_no`,`p`.`column_no` AS `column_no`,`tc`.`task_id` AS `task_id`,`ti`.`parameter_id` AS `parameter_id`,`p`.`name` AS `parameter_name`,`ti`.`data_value` AS `data_value`,`ti`.`created_by` AS `created_by`,`ti`.`created_at` AS `created_at`,`ti`.`updated_by` AS `updated_by`,`ti`.`updated_at` AS `updated_at` from (((`parameter_contexts` `pc` join `parameters` `p`) join `task_contexts` `tc`) join `task_values` `ti`) where ((`ti`.`task_context_id` = `tc`.`id`) and (`p`.`id` = `ti`.`parameter_id`) and (`pc`.`id` = `tc`.`parameter_context_id`)) union select `ti`.`id` AS `id`,`pc`.`protocol_version_id` AS `protocol_version_id`,`pc`.`id` AS `parameter_context_id`,`pc`.`label` AS `label`,`tc`.`label` AS `row_label`,`tc`.`row_no` AS `row_no`,`p`.`column_no` AS `column_no`,`tc`.`task_id` AS `task_id`,`ti`.`parameter_id` AS `parameter_id`,`p`.`name` AS `parameter_name`,`ti`.`data_content` AS `data_value`,`ti`.`created_by` AS `created_by`,`ti`.`created_at` AS `created_at`,`ti`.`updated_by` AS `updated_by`,`ti`.`updated_at` AS `updated_at` from (((`parameter_contexts` `pc` join `parameters` `p`) join `task_contexts` `tc`) join `task_texts` `ti`) where ((`ti`.`task_context_id` = `tc`.`id`) and (`p`.`id` = `ti`.`parameter_id`) and (`pc`.`id` = `tc`.`parameter_context_id`)) union select `ti`.`id` AS `id`,`pc`.`protocol_version_id` AS `protocol_version_id`,`pc`.`id` AS `parameter_context_id`,`pc`.`label` AS `label`,`tc`.`label` AS `row_label`,`tc`.`row_no` AS `row_no`,`p`.`column_no` AS `column_no`,`tc`.`task_id` AS `task_id`,`ti`.`parameter_id` AS `parameter_id`,`p`.`name` AS `parameter_name`,`ti`.`data_content` AS `data_value`,`ti`.`created_by` AS `created_by`,`ti`.`created_at` AS `created_at`,`ti`.`updated_by` AS `updated_by`,`ti`.`updated_at` AS `updated_at` from (((`parameter_contexts` `pc` join `parameters` `p`) join `task_contexts` `tc`) join `task_texts` `ti`) where ((`ti`.`task_context_id` = `tc`.`id`) and (`p`.`id` = `ti`.`parameter_id`) and (`pc`.`id` = `tc`.`parameter_context_id`)) union select `ti`.`id` AS `id`,`pc`.`protocol_version_id` AS `protocol_version_id`,`pc`.`id` AS `parameter_context_id`,`pc`.`label` AS `label`,`tc`.`label` AS `row_label`,`tc`.`row_no` AS `row_no`,`p`.`column_no` AS `column_no`,`tc`.`task_id` AS `task_id`,`ti`.`parameter_id` AS `parameter_id`,`p`.`name` AS `parameter_name`,`ti`.`data_name` AS `data_value`,`ti`.`created_by` AS `created_by`,`ti`.`created_at` AS `created_at`,`ti`.`updated_by` AS `updated_by`,`ti`.`updated_at` AS `updated_at` from (((`parameter_contexts` `pc` join `parameters` `p`) join `task_contexts` `tc`) join `task_references` `ti`) where ((`ti`.`task_context_id` = `tc`.`id`) and (`p`.`id` = `ti`.`parameter_id`) and (`pc`.`id` = `tc`.`parameter_context_id`)) */;

--
-- Final view structure for view `task_statistics`
--

/*!50001 DROP TABLE IF EXISTS `task_statistics`*/;
/*!50001 DROP VIEW IF EXISTS `task_statistics`*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`biorails`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `task_statistics` AS select ((`r`.`task_id` * 100000) + `r`.`parameter_id`) AS `id`,`r`.`task_id` AS `task_id`,`r`.`parameter_id` AS `parameter_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,`p`.`data_type_id` AS `data_type_id`,avg(`r`.`data_value`) AS `avg_values`,std(`r`.`data_value`) AS `stddev_values`,count(`r`.`data_value`) AS `num_values`,count(distinct `r`.`data_value`) AS `num_unique`,max(`r`.`data_value`) AS `max_values`,min(`r`.`data_value`) AS `min_values` from (`task_values` `r` join `parameters` `p`) where (`p`.`id` = `r`.`parameter_id`) group by `r`.`task_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`data_type_id` union select ((`r`.`task_id` * 100000) + `r`.`parameter_id`) AS `id`,`r`.`task_id` AS `task_id`,`r`.`parameter_id` AS `parameter_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,`p`.`data_type_id` AS `data_type_id`,sum(NULL) AS `avg_values`,sum(NULL) AS `stddev_values`,count(`r`.`id`) AS `num_values`,count(distinct `r`.`data_content`) AS `num_unique`,min(`r`.`data_content`) AS `max_values`,max(`r`.`data_content`) AS `min_values` from (`task_texts` `r` join `parameters` `p`) where (`p`.`id` = `r`.`parameter_id`) group by `r`.`task_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`data_type_id` union select ((`r`.`task_id` * 100000) + `r`.`parameter_id`) AS `id`,`r`.`task_id` AS `task_id`,`r`.`parameter_id` AS `parameter_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,`p`.`data_type_id` AS `data_type_id`,sum(NULL) AS `avg_values`,sum(NULL) AS `stddev_values`,count(`r`.`id`) AS `num_values`,count(distinct `r`.`data_name`) AS `num_unique`,max(`r`.`data_name`) AS `max_values`,min(`r`.`data_name`) AS `min_values` from (`task_references` `r` join `parameters` `p`) where (`p`.`id` = `r`.`parameter_id`) group by `r`.`task_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`data_type_id` */;

--
-- Final view structure for view `task_stats1`
--

/*!50001 DROP TABLE IF EXISTS `task_stats1`*/;
/*!50001 DROP VIEW IF EXISTS `task_stats1`*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `task_stats1` AS select `r`.`task_id` AS `task_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,`p`.`data_type_id` AS `data_type_id`,avg(`r`.`data_value`) AS `avg_values`,std(`r`.`data_value`) AS `stddev_values`,count(`r`.`data_value`) AS `num_values`,count(distinct `r`.`data_value`) AS `num_unique`,max(`r`.`data_value`) AS `max_values`,min(`r`.`data_value`) AS `min_values` from (`task_values` `r` join `parameters` `p`) where (`p`.`id` = `r`.`parameter_id`) group by `r`.`task_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`data_type_id` union select `r`.`task_id` AS `task_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,`p`.`data_type_id` AS `data_type_id`,sum(NULL) AS `avg_values`,sum(NULL) AS `stddev_values`,count(`r`.`id`) AS `num_values`,count(distinct `r`.`data_content`) AS `num_unique`,sum(NULL) AS `max_values`,sum(NULL) AS `min_values` from (`task_texts` `r` join `parameters` `p`) where (`p`.`id` = `r`.`parameter_id`) group by `r`.`task_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`data_type_id` union select `r`.`task_id` AS `task_id`,`p`.`parameter_role_id` AS `parameter_role_id`,`p`.`parameter_type_id` AS `parameter_type_id`,`p`.`data_type_id` AS `data_type_id`,sum(NULL) AS `avg_values`,sum(NULL) AS `stddev_values`,count(`r`.`id`) AS `num_values`,count(distinct `r`.`data_name`) AS `num_unique`,max(`r`.`data_id`) AS `max_values`,min(`r`.`data_id`) AS `min_values` from (`task_references` `r` join `parameters` `p`) where (`p`.`id` = `r`.`parameter_id`) group by `r`.`task_id`,`p`.`parameter_role_id`,`p`.`parameter_type_id`,`p`.`data_type_id` */;

--
-- Final view structure for view `task_stats2`
--

/*!50001 DROP TABLE IF EXISTS `task_stats2`*/;
/*!50001 DROP VIEW IF EXISTS `task_stats2`*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `task_stats2` AS select `r`.`task_id` AS `task_id`,`r`.`parameter_id` AS `parameter_id`,avg(`r`.`data_value`) AS `avg_values`,std(`r`.`data_value`) AS `stddev_values`,count(`r`.`data_value`) AS `num_values`,count(distinct `r`.`data_value`) AS `num_unique`,max(`r`.`data_value`) AS `max_values`,min(`r`.`data_value`) AS `min_values` from `task_values` `r` group by `r`.`task_id`,`r`.`parameter_id` union select `r`.`task_id` AS `task_id`,`r`.`parameter_id` AS `parameter_id`,sum(NULL) AS `avg_values`,sum(NULL) AS `stddev_values`,count(`r`.`id`) AS `num_values`,count(distinct `r`.`data_content`) AS `num_unique`,sum(NULL) AS `max_values`,sum(NULL) AS `min_values` from `task_texts` `r` group by `r`.`task_id`,`r`.`parameter_id` union select `r`.`task_id` AS `task_id`,`r`.`parameter_id` AS `parameter_id`,sum(NULL) AS `avg_values`,sum(NULL) AS `stddev_values`,count(`r`.`id`) AS `num_values`,count(distinct `r`.`data_name`) AS `num_unique`,max(`r`.`data_id`) AS `max_values`,min(`r`.`data_id`) AS `min_values` from `task_references` `r` group by `r`.`task_id`,`r`.`parameter_id` */;

--
-- Final view structure for view `view_controller_actions`
--

/*!50001 DROP TABLE IF EXISTS `view_controller_actions`*/;
/*!50001 DROP VIEW IF EXISTS `view_controller_actions`*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_controller_actions` AS select `controller_actions`.`id` AS `id`,`site_controllers`.`id` AS `site_controller_id`,`site_controllers`.`name` AS `site_controller_name`,`controller_actions`.`name` AS `name`,coalesce(`controller_actions`.`permission_id`,`site_controllers`.`permission_id`) AS `permission_id` from (`site_controllers` join `controller_actions` on((`site_controllers`.`id` = `controller_actions`.`site_controller_id`))) */;

--
-- Final view structure for view `view_menu_items`
--

/*!50001 DROP TABLE IF EXISTS `view_menu_items`*/;
/*!50001 DROP VIEW IF EXISTS `view_menu_items`*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_menu_items` AS select cast(`menu_items`.`id` as unsigned) AS `menu_item_id`,`menu_items`.`name` AS `menu_item_name`,`menu_items`.`label` AS `menu_item_label`,`menu_items`.`seq` AS `menu_item_seq`,`menu_items`.`parent_id` AS `menu_item_parent_id`,`view_controller_actions`.`site_controller_id` AS `site_controller_id`,`view_controller_actions`.`site_controller_name` AS `site_controller_name`,`view_controller_actions`.`id` AS `controller_action_id`,`view_controller_actions`.`name` AS `controller_action_name`,`biorails_development`.`content_pages`.`id` AS `content_page_id`,`biorails_development`.`content_pages`.`name` AS `content_page_name`,`biorails_development`.`content_pages`.`title` AS `content_page_title`,`biorails_development`.`permissions`.`id` AS `permission_id`,`biorails_development`.`permissions`.`name` AS `permission_name` from ((((`menu_items` left join `view_controller_actions` on((`biorails_development`.`menu_items`.`controller_action_id` = `view_controller_actions`.`id`))) left join `content_pages` on(((`biorails_development`.`menu_items`.`content_page_id` = `biorails_development`.`content_pages`.`id`) and isnull(`biorails_development`.`menu_items`.`controller_action_id`)))) left join `markup_styles` on((`biorails_development`.`content_pages`.`markup_style_id` = `biorails_development`.`markup_styles`.`id`))) join `permissions` on((coalesce(`view_controller_actions`.`permission_id`,`biorails_development`.`content_pages`.`permission_id`) = `biorails_development`.`permissions`.`id`))) */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

