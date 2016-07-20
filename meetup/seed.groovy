def repositories = [
    'hackharassment',
    'healthcheck',
    'go',
]

// Create a Pipeline Multibranch job for each repository.
repositories.each {
    // Our Jenkins instance currently restricts job IDs to /[a-zA-Z0-9_]+/.
    def job = it.replaceAll('-', '_')
    def repo = it
    multibranchPipelineJob(job) {
        branchSources {
            // The workflow-multibranch + github-branch-source combination
            // is not yet supported by the Jenkins DSL plugin. Write the XML
            // directly for now.
            configure { node ->
                node / 'sources' / 'data' / 'jenkins.branch.BranchSource' {
                    source(class:'org.jenkinsci.plugins.github_branch_source.GitHubSCMSource',
                           plugin:'github-branch-source@1.3') {
                        id("meetup:${repo}")
                        apiUri('https://api.github.com/')
                        repoOwner('tomwillfixit')
                        repository(repo)
                        includes('*')
                        excludes('')
                    }
                    strategy(class:'jenkins.branch.DefaultBranchPropertyStrategy') {
                        properties(class:'empty-list')
                    }
                }
            }
        }
        triggers {
            periodic(30)
        }
        orphanedItemStrategy {
            discardOldItems {
                daysToKeep(0)
                numToKeep(0)
            }
        }
    }
}

// Create an Meetup view that contains the `master` branch of each
// Pipeline Multibranch job created above, as well as the seed job that
// runs this Groovy code.
listView('MeetupDemo') {
    description('Sample projects in Meetup Demo')
    recurse()
    jobs {
        name('meetup_seed')
        names(*repositories.collect { it.replaceAll('-', '_') + '/master' })
    }
    columns {
        status()
        weather()
        name()
        lastSuccess()
        lastFailure()
        lastDuration()
        buildButton()
    }
}
