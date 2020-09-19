<?php

/**
 * @file AuthorDAO.inc.php
 *
 * Copyright (c) 2000-2012 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class AuthorDAO
 * @ingroup paper
 * @see Author
 *
 * @brief Operations for retrieving and modifying Author objects.
 */

//$Id$

import('paper.Author');
import('paper.Paper');

class AuthorDAO extends DAO {
	/**
	 * Retrieve an author by ID.
	 * @param $authorId int
	 * @return Author
	 */
	function &getAuthor($authorId) {
		$result =& $this->retrieve(
			'SELECT * FROM paper_authors WHERE author_id = ?', $authorId
		);

		$returner = null;
		if ($result->RecordCount() != 0) {
			$returner =& $this->_returnAuthorFromRow($result->GetRowAssoc(false));
		}

		$result->Close();
		unset($result);

		return $returner;
	}

	/**
	 * Retrieve all authors for a paper.
	 * @param $paperId int
	 * @return array Authors ordered by sequence
	 */
	function &getAuthorsByPaper($paperId) {
		$authors = array();

		$result =& $this->retrieve(
			'SELECT * FROM paper_authors WHERE paper_id = ? ORDER BY seq',
			$paperId
		);

		while (!$result->EOF) {
			$authors[] =& $this->_returnAuthorFromRow($result->GetRowAssoc(false));
			$result->moveNext();
		}

		$result->Close();
		unset($result);

		return $authors;
	}

	/**
	 * Retrieve all published papers associated with authors with
	 * the given first name, middle name, last name, affiliation, and country.
	 * @param $schedConfId int (null if no restriction desired)
	 * @param $firstName string
	 * @param $middleName string
	 * @param $lastName string
	 * @param $affiliation string
	 * @param $country string
	 */
	function &getPublishedPapersForAuthor($schedConfId, $firstName, $middleName, $lastName, $affiliation, $country) {
		$publishedPapers = array();
		$publishedPaperDao =& DAORegistry::getDAO('PublishedPaperDAO');
		$params = array($firstName, $middleName, $lastName, $affiliation, $country);
		if ($schedConfId !== null) $params[] = $schedConfId;

		$result =& $this->retrieve(
			'SELECT DISTINCT
				aa.paper_id
			FROM paper_authors aa
				LEFT JOIN papers a ON (aa.paper_id = a.paper_id)
			WHERE aa.first_name = ? AND
				a.status = ' . STATUS_PUBLISHED . ' AND
				(aa.middle_name = ?' . (empty($middleName)?' OR aa.middle_name IS NULL':'') .  ') AND
				aa.last_name = ? AND
				(aa.affiliation = ?' . (empty($affiliation)?' OR aa.affiliation IS NULL':'') . ') AND
				(aa.country = ?' . (empty($country)?' OR aa.country IS NULL':'') . ')' .
				($schedConfId!==null?(' AND a.sched_conf_id = ?'):''),
			$params
		);

		while (!$result->EOF) {
			$row =& $result->getRowAssoc(false);
			$publishedPaper =& $publishedPaperDao->getPublishedPaperByPaperId($row['paper_id']);
			if ($publishedPaper) {
				$publishedPapers[] =& $publishedPaper;
			}
			$result->moveNext();
		}

		$result->Close();
		unset($result);

		return $publishedPapers;
	}

	/**
	 * Retrieve all published authors for a scheduled conference.
	 * Note that if schedConfId is null, alphabetized authors for all
	 * scheduled conferences are returned.
	 * @param $schedConfId int
	 * @param $initial An initial the last names must begin with
	 * @param $rangeInfo Range information
	 * @param $includeEmail Whether or not to include the email in the select distinct
	 * @return object ItemIterator Authors ordered by sequence
	 */
	function &getAuthorsAlphabetizedBySchedConf($schedConfId = null, $initial = null, $rangeInfo = null, $includeEmail = false) {
		$params = array();

		if (isset($schedConfId)) $params[] = $schedConfId;
		if (isset($initial)) {
			$params[] = String::strtolower($initial) . '%';
			$initialSql = ' AND LOWER(aa.last_name) LIKE LOWER(?)';
		} else {
			$initialSql = '';
		}

		$result =& $this->retrieveRange(
			'SELECT	DISTINCT CAST(\'\' AS CHAR) AS url,
				0 AS author_id,
				0 AS paper_id,
				' . ($includeEmail?'aa.email AS email,':'CAST(\'\' AS CHAR) AS email,') . '
				0 AS primary_contact,
				0 AS seq,
				aa.first_name AS first_name,
				aa.middle_name AS middle_name,
				aa.last_name AS last_name,
				aa.affiliation_select AS affiliation_select,
				aa.affiliation AS affiliation,
				aa.country FROM paper_authors aa,
				papers a,
				published_papers pa,
				sched_confs e
			WHERE	e.sched_conf_id = pa.sched_conf_id
				AND aa.paper_id = a.paper_id
				' . (isset($schedConfId)?'AND a.sched_conf_id = ? ':'') . '
				AND pa.paper_id = a.paper_id
				AND a.status = ' . STATUS_PUBLISHED . '
				AND (aa.last_name IS NOT NULL
				AND aa.last_name <> \'\')' . $initialSql . ' ORDER BY aa.last_name, aa.first_name',
			empty($params)?false:$params,
			$rangeInfo
		);

		$returner = new DAOResultFactory($result, $this, '_returnAuthorFromRow');
		return $returner;
	}

	/**
	 * Retrieve all authors with given decision in given stage for papers still in review a scheduled conference.
	 * Note that if schedConfId is null, alphabetized authors for all
	 * scheduled conferences are returned.
	 * @param $schedConfId int
	 * @param $status status of the wanted papers; if null then both Published and Queued
	 * @param $stage stage where the autors must have paper; if null then all stages at once
	 * @param $decision decision from the stage; if stage null then not sure which decisions to choose if collision
	 * @param $includeEmail Whether or not to include the email in the select distinct
	 * @return object ItemIterator Authors ordered by sequence
	 */
	function &getAuthorsAlphabetizedByStageAndDecision($schedConfId = null, $status = null, $stage = null, $decision = null, $includeEmail = false) {
		$params = array();
		$rangeInfo = null;

		if (isset($schedConfId)) $params[] = $schedConfId;

		if (isset($status)) {
			$params[] = $status;
			$statusSql = ' AND a.status = ?';
		} else {
			$statusSql = 'AND (a.status = ' . STATUS_PUBLISHED . ' OR a.status = ' . STATUS_QUEUED . ')';
		}

		if (isset($stage)) {
			$params[] = $stage;
			$stageSql = ' AND (ed.paper_id, ed.date_decided) IN (
											SELECT ed2.paper_id, MAX(ed2.date_decided)
											FROM edit_decisions AS ed2
											WHERE ed2.stage = ?
											GROUP BY ed2.paper_id)';
		} else {
			$stageSql = '';
		}

		if (isset($decision)) {
			$params[] = $decision;
			$decisionSql = ' AND ed.decision = ?';
		} else {
			$decisionSql = '';
		}

		$result =& $this->retrieveRange(
			'SELECT	DISTINCT CAST(\'\' AS CHAR) AS url,
				0 AS author_id,
				0 AS paper_id,
				' . ($includeEmail?'aa.email AS email,':'CAST(\'\' AS CHAR) AS email,') . '
				0 AS primary_contact,
				0 AS seq,
				aa.first_name AS first_name,
				aa.middle_name AS middle_name,
				aa.last_name AS last_name,
				aa.affiliation_select AS affiliation_select,
				aa.affiliation AS affiliation,
				aa.country
				FROM users aa,
				papers a,
				sched_confs e,
				edit_decisions ed
			WHERE aa.user_id = a.user_id
				' . (isset($schedConfId)?'AND a.sched_conf_id = ? ':'') . '
				AND a.paper_id = ed.paper_id ' . $statusSql . '
				AND (aa.last_name IS NOT NULL
				AND aa.last_name <> \'\')' . $stageSql . $decisionSql . ' ORDER BY aa.last_name, aa.first_name',
			empty($params)?false:$params,
			$rangeInfo
		);
		
		$returner = new DAOResultFactory($result, $this, '_returnAuthorFromRow');
		return $returner;
	}

	/**
	 * Retrieve unique submitters for scheduled conference with accepted abstracts for REVIEW_STAGE_ABSTRACT
	 * or published papers and papers in review for > REVIEW_STAGE_ABSTRACT
	 * Accepted abstract means Accepted or Accepted with suggestions 
	 * Note that if schedConfId is null, alphabetized authors for all
	 * scheduled conferences are returned.
	 * If stage null then accepted papers and papers for review will be selected
	 * @param $schedConfId int
	 * @param $stage stage abstract or review; if null then all stages
	 * @param $includeEmail Whether or not to include the email in the select distinct
	 * @return object ItemIterator Authors ordered by sequence
	 */

	function &getAuthorsAlphabetizedSubmissionAccepted($schedConfId = null, $stage = null, $includeEmail = false) {
		$params = array();
		$rangeInfo = null;

		if (isset($schedConfId)) $params[] = $schedConfId;

		/* if (isset($status)) {
			$params[] = $status;
			$statusSql = ' AND a.status = ?';
		} else {
			$statusSql = ' AND (a.status = ' . STATUS_PUBLISHED . ' OR a.status = ' . STATUS_QUEUED . ')';
		} */

		if ($stage <> REVIEW_STAGE_ABSTRACT) {
			$statusSql = ' AND (a.status = ' . STATUS_PUBLISHED . ' OR a.status = ' . STATUS_QUEUED . ')';
			$sub_progress = ' AND a.submission_progress = 0'; // papers with uploaded first review file
		}
		else {
			$statusSql = ' AND a.status = ' . STATUS_QUEUED . ' AND a.current_stage = 2'; // first paper review stage
			$sub_progress = ' AND a.submission_progress = 2'; // papers waiting to upload first review file
		}

		$result =& $this->retrieveRange(
			'SELECT	DISTINCT CAST(\'\' AS CHAR) AS url,
				0 AS author_id,
				0 AS paper_id,
				' . ($includeEmail?'aa.email AS email,':'CAST(\'\' AS CHAR) AS email,') . '
				0 AS primary_contact,
				0 AS seq,
				aa.first_name AS first_name,
				aa.middle_name AS middle_name,
				aa.last_name AS last_name,
				aa.affiliation_select AS affiliation_select,
				aa.affiliation AS affiliation,
				aa.country
				FROM users aa,
				papers a,
				sched_confs e,
				edit_decisions ed
			WHERE aa.user_id = a.user_id
				' . (isset($schedConfId)?'AND a.sched_conf_id = ? ':'') . '
				AND a.paper_id = ed.paper_id' . $sub_progress . $statusSql . '
				AND (aa.last_name IS NOT NULL
				AND aa.last_name <> \'\')' . ' ORDER BY aa.last_name, aa.first_name',
			empty($params)?false:$params,
			$rangeInfo
		);
		
		$returner = new DAOResultFactory($result, $this, '_returnAuthorFromRow');
		return $returner;
	}

	/**
	 * Retrieve all authors for scheduled conference with papers still in review
	 * and decision for revisions who did not submit revision file yet.
	 * Note that if schedConfId is null, alphabetized authors for all
	 * scheduled conferences are returned.
	 * @param $schedConfId int
	 * @param $status status of the wanted papers; if null then both Published and Queued
	 * @param $includeEmail Whether or not to include the email in the select distinct
	 * @return object ItemIterator Authors ordered by sequence
	 */
	function &getAuthorsAlphabetizedRevisionsPending($schedConfId = null, $status = null, $includeEmail = false) {
		$params = array();
		$rangeInfo = null;

		if (isset($schedConfId)) $params[] = $schedConfId;

		if (isset($status)) {
			$params[] = $status;
			$statusSql = ' AND a.status = ?';
		} else {
			$statusSql = 'AND (a.status = ' . STATUS_PUBLISHED . ' OR a.status = ' . STATUS_QUEUED . ')';
		}

		// only decisions for paper revisions
		$decisionSql = ' AND (ed.decision = ' . SUBMISSION_DIRECTOR_DECISION_PENDING_MINOR_REVISIONS . ' OR ed.decision = ' . SUBMISSION_DIRECTOR_DECISION_PENDING_MAJOR_REVISIONS . ')';
		// return papers which don't have a revised version uploaded for current stage
		$paperFileSql = " AND (a.paper_id, a.current_stage) NOT IN (
			SELECT pf2.paper_id, pf2.stage
			FROM paper_files AS pf2
			WHERE pf2.type LIKE 'submission/director')";

		$result =& $this->retrieveRange(
			'SELECT	DISTINCT CAST(\'\' AS CHAR) AS url,
				0 AS author_id,
				0 AS paper_id,
				' . ($includeEmail?'aa.email AS email,':'CAST(\'\' AS CHAR) AS email,') . '
				0 AS primary_contact,
				0 AS seq,
				aa.first_name AS first_name,
				aa.middle_name AS middle_name,
				aa.last_name AS last_name,
				aa.affiliation_select AS affiliation_select,
				aa.affiliation AS affiliation,
				aa.country
				FROM users aa,
				papers a,
				sched_confs e,
				edit_decisions ed,
				paper_files pf
			WHERE aa.user_id = a.user_id
				' . (isset($schedConfId)?'AND a.sched_conf_id = ? ':'') . '
				AND a.paper_id = ed.paper_id
				AND a.current_stage = ed.stage ' . $statusSql . '
				AND (aa.last_name IS NOT NULL
				AND aa.last_name <> \'\')
				AND a.paper_id = pf.paper_id' . $decisionSql . $paperFileSql . ' ORDER BY aa.last_name, aa.first_name',
			empty($params)?false:$params,
			$rangeInfo
		);
		
		$returner = new DAOResultFactory($result, $this, '_returnAuthorFromRow');
		return $returner;
	}

	/**
	 * Retrieve the IDs of all authors for a paper.
	 * @param $paperId int
	 * @return array int ordered by sequence
	 */
	function &getAuthorIdsByPaper($paperId) {
		$authors = array();

		$result =& $this->retrieve(
			'SELECT author_id FROM paper_authors WHERE paper_id = ? ORDER BY seq',
			$paperId
		);

		while (!$result->EOF) {
			$authors[] = $result->fields[0];
			$result->moveNext();
		}

		$result->Close();
		unset($result);

		return $authors;
	}

	/**
	 * Get field names for which data is localized.
	 * @return array
	 */
	function getLocaleFieldNames() {
		return array('biography');
	}

	/**
	 * Update the localized data for this object
	 * @param $author object
	 */
	function updateLocaleFields(&$author) {
		$this->updateDataObjectSettings('paper_author_settings', $author, array(
			'author_id' => $author->getId()
		));

	}

	/**
	 * Internal function to return an Author object from a row.
	 * @param $row array
	 * @return Author
	 */
	function &_returnAuthorFromRow(&$row) {
		$author = new Author();
		$author->setId($row['author_id']);
		$author->setPaperId($row['paper_id']);
		$author->setFirstName($row['first_name']);
		$author->setMiddleName($row['middle_name']);
		$author->setLastName($row['last_name']);
		$author->setAffiliationSelect($row['affiliation_select']);
		$author->setAffiliation($row['affiliation']);
		$author->setCountry($row['country']);
		$author->setEmail($row['email']);
		$author->setUrl($row['url']);
		$author->setPrimaryContact($row['primary_contact']);
		$author->setSequence($row['seq']);

		$this->getDataObjectSettings('paper_author_settings', 'author_id', $row['author_id'], $author);

		HookRegistry::call('AuthorDAO::_returnAuthorFromRow', array(&$author, &$row));

		return $author;
	}

	/**
	 * Insert a new Author.
	 * @param $author Author
	 */
	function insertAuthor(&$author) {
		$this->update(
			'INSERT INTO paper_authors
				(paper_id, first_name, middle_name, last_name, affiliation_select, affiliation, country, email, url, primary_contact, seq)
				VALUES
				(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
			array(
				$author->getPaperId(),
				$author->getFirstName(),
				$author->getMiddleName() . '', // make non-null
				$author->getLastName(),
				$author->getAffiliationSelect() . '', // make non-null
				$author->getAffiliation() . '', // make non-null
				$author->getCountry(),
				$author->getEmail(),
				$author->getUrl(),
				(int) $author->getPrimaryContact(),
				(float) $author->getSequence()
			)
		);

		$author->setId($this->getInsertAuthorId());
		$this->updateLocaleFields($author);

		return $author->getId();
	}

	/**
	 * Update an existing Author.
	 * @param $author Author
	 */
	function updateAuthor(&$author) {
		$returner = $this->update(
			'UPDATE paper_authors
				SET
					first_name = ?,
					middle_name = ?,
					last_name = ?,
					affiliation_select = ?,
					affiliation = ?,
					country = ?,
					email = ?,
					url = ?,
					primary_contact = ?,
					seq = ?
				WHERE author_id = ?',
			array(
				$author->getFirstName(),
				$author->getMiddleName() . '', // make non-null
				$author->getLastName(),
				$author->getAffiliationSelect() . '', // make non-null
				$author->getAffiliation() . '', // make non-null
				$author->getCountry(),
				$author->getEmail(),
				$author->getUrl(),
				$author->getPrimaryContact(),
				$author->getSequence(),
				$author->getId()
			)
		);
		$this->updateLocaleFields($author);
		return $returner;
	}

	/**
	 * Delete an Author.
	 * @param $author Author
	 */
	function deleteAuthor(&$author) {
		return $this->deleteAuthorById($author->getId());
	}

	/**
	 * Delete an author by ID.
	 * @param $authorId int
	 * @param $paperId int optional
	 */
	function deleteAuthorById($authorId, $paperId = null) {
		$params = array($authorId);
		if ($paperId) $params[] = $paperId;
		$returner = $this->update(
			'DELETE FROM paper_authors WHERE author_id = ?' .
			($paperId?' AND paper_id = ?':''),
			$params
		);
		if ($returner) $this->update('DELETE FROM paper_author_settings WHERE author_id = ?', array($authorId));
	}

	/**
	 * Delete authors by paper.
	 * @param $paperId int
	 */
	function deleteAuthorsByPaper($paperId) {
		$authors =& $this->getAuthorsByPaper($paperId);
		foreach ($authors as $author) {
			$this->deleteAuthor($author);
		}
	}

	/**
	 * Sequentially renumber a paper's authors in their sequence order.
	 * @param $paperId int
	 */
	function resequenceAuthors($paperId) {
		$result =& $this->retrieve(
			'SELECT author_id FROM paper_authors WHERE paper_id = ? ORDER BY seq', $paperId
		);

		for ($i=1; !$result->EOF; $i++) {
			list($authorId) = $result->fields;
			$this->update(
				'UPDATE paper_authors SET seq = ? WHERE author_id = ?',
				array(
					$i,
					$authorId
				)
			);

			$result->moveNext();
		}

		$result->close();
		unset($result);
	}

	/**
	 * Get the ID of the last inserted author.
	 * @return int
	 */
	function getInsertAuthorId() {
		return $this->getInsertId('paper_authors', 'author_id');
	}
}

?>
