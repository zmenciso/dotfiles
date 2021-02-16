import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import "lib"
import "lib/TimeUtils.js" as TimeUtils

IssueListView {
	id: issueListView

	isSetup: widget.repoStringList.length >= 1
	showHeading: plasmoid.configuration.showHeading
	headingText: {
		if (plasmoid.configuration.headingText) {
			return plasmoid.configuration.headingText
		} else {
			return widget.repoStringList.join(', ')
		}
	}

	delegate: IssueListItem {
		issueOpen: issue.state == 'open'
		issueId: issue.number
		issueSummary: issue.title
		category: {
			if (widget.repoStringList.length >= 2) {
				var repoFullName = issue.repository_url.substr('https://api.github.com/repos/'.length)
				return repoFullName
			} else {
				return ""
			}
		}
		issueCreatorName: issue.user.login
		issueHtmlLink: issue.html_url
		showNumComments: issue.comments > 0
		numComments: issue.comments

		dateTime: {
			if (issueOpen) {
				return issue.created_at
			} else { // Closed
				return issue.closed_at
			}
		}

		issueState: {
			if (issue.pull_request) {
				if (issue.state == 'open') {
					return 'openPullRequest'
				} else { // 'closed'
					// Note, there's currently no way to tell if a pull request was merged
					// or if it was closed. To find that out, we'd need to query 
					// the pull request api endpoint as well.
					if (true) { // issue.merged
						return 'merged'
					} else {
						return 'closedPullRequest'
					}
				}
			} else {
				if (issue.state == 'open') {
					return 'opened'
				} else { // 'closed'
					return 'closed'
				}
			}
		}
	}
}
