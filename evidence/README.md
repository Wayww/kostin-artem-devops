# Verification Evidence

These files contain command output captured from the working project:

- `linux-evidence.txt` - search, log processing, permissions and process data.
- `linux-container-evidence.txt` - the complete demo executed in a Linux container.
- `git-evidence.txt` - status, branches, commit graph, remote and ignore rules.
- `docker-evidence.txt` - image, container, logs, environment check and health.
- `docker-lifecycle.txt` - build, run, ps, logs, exec, stop, start, rm and Compose.
- `jenkins-console.txt` - complete Jenkins Pipeline Console Output.
- `jenkins-build.json` - Jenkins build result and metadata.
- `screenshots/` - live GitHub, Jenkins Stage View, build and Console Output.

Recreate the Linux, Git and Docker evidence with:

```bash
./scripts/collect_evidence.sh
./scripts/verify_docker_workflow.sh
./scripts/run_linux_container_demo.sh
```

Recreate the Jenkins evidence with:

```bash
./scripts/run_jenkins_lab.sh
```
