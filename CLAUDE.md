# CLAUDE.md - AI Assistant Guide

## Repository Overview

This repository contains **Oracle SQL troubleshooting utilities** designed for database administrators and support engineers. The primary focus is proactive SQL performance diagnosis and automated recommendations.

**Repository:** `Nirmal7086/2025`
**Primary Language:** Bash/Shell Script
**Target Environment:** Linux/Unix with Oracle Database
**Purpose:** SQL_ID performance analysis and troubleshooting automation

---

## Codebase Structure

```
/home/user/2025/
├── .git/                      # Git version control
├── sql_troubleshoot.sh        # Main Oracle SQL diagnostics script (249 lines)
└── CLAUDE.md                  # This file - AI assistant documentation
```

### Key Files

#### `sql_troubleshoot.sh`
- **Purpose:** Comprehensive SQL_ID performance diagnosis tool
- **Lines:** 249
- **Usage:** `./sql_troubleshoot.sh <SQL_ID> [ORACLE_SID]`
- **Requirements:** Oracle Database access with DBA privileges
- **Output:** Formatted diagnostic report with automated recommendations

---

## Development Workflow

### Branching Strategy

**Feature Branch Pattern:**
- All development occurs on feature branches with pattern: `claude/<description>-<sessionId>`
- Current active branch: `claude/add-claude-documentation-NuXtH`
- Main branch exists but no explicit name configured in this repository
- **CRITICAL:** Branch names MUST start with `claude/` and match session ID for push operations

### Git Operations

**Committing:**
- Use descriptive commit messages focusing on "why" not "what"
- Example: "Add proactive Oracle SQL_ID diagnosis and recommendation script"
- Commits are signed using SSH signing (`/home/claude/.ssh/commit_signing_key.pub`)
- User: Claude (noreply@anthropic.com)

**Pushing:**
- Always use: `git push -u origin <branch-name>`
- Branch MUST follow naming convention: `claude/*-<sessionId>`
- Retry logic: Up to 4 retries with exponential backoff (2s, 4s, 8s, 16s) for network failures
- Push failures with 403 indicate branch naming violation

**Pulling/Fetching:**
- Prefer specific branch fetches: `git fetch origin <branch-name>`
- For pulls: `git pull origin <branch-name>`
- Apply same retry logic for network failures

### Pull Request Process

1. Ensure all changes are committed to feature branch
2. Push branch to remote: `git push -u origin claude/<description>-<sessionId>`
3. Create PR with:
   - Clear title describing the change
   - Summary with 1-3 bullet points
   - Test plan with checklist of verification steps
4. Use `gh pr create` for PR creation

---

## Code Conventions and Best Practices

### Shell Script Standards

#### Error Handling
```bash
set -euo pipefail  # Strict error handling
- e: Exit on error
- u: Exit on undefined variable
- o pipefail: Fail on pipe errors
```

#### Output Formatting
- **Color-coded output:** Uses ANSI color codes
  - `RED`: Errors
  - `GREEN`: Success messages
  - `YELLOW`: Warnings
  - `BLUE`: Info and headers
  - `NC`: Reset to no color

#### Helper Functions Pattern
```bash
print_header()   # Section headers with blue borders
print_success()  # Green success messages
print_warning()  # Yellow warnings
print_error()    # Red error messages
print_info()     # Blue informational messages
```

#### Input Validation
- Always validate required parameters before execution
- Provide clear usage messages on error
- Support optional parameters with sensible defaults

#### Environment Setup
- Export required environment variables (`ORACLE_SID`, `ORAENV_ASK`)
- Source Oracle environment scripts with fallback paths
- Fail fast with clear error messages if environment unavailable

### SQL Execution Pattern

**Standard Template:**
```bash
execute_sql() {
    local query="$1"
    sqlplus -S / as sysdba <<EOF
SET PAGESIZE 1000
SET LINESIZE 200
SET FEEDBACK OFF
SET HEADING ON
SET VERIFY OFF
$query
EXIT;
EOF
}
```

**SQL Formatting Standards:**
- Use consistent indentation
- One column per line in SELECT statements
- Include meaningful column aliases
- Filter by SQL_ID using variable interpolation: `WHERE sql_id = '$SQL_ID'`

### Documentation Standards

#### Script Headers
Every script should include:
```bash
################################################################################
# Script Name
# Purpose: Clear description of functionality
# Usage: Command syntax with parameters
################################################################################
```

#### Section Headers
Major sections should be clearly delineated:
```bash
################################################################################
# N. Section Title
################################################################################
```

---

## Key Technologies

### Oracle Database Components

**Dynamic Performance Views (`v$`):**
- `v$sql` - SQL statements in shared pool
- `v$sql_plan` - Execution plans
- `v$session` - Current session information
- `v$sql_monitor` - Real-time SQL monitoring
- `v$sql_bind_capture` - Bind variable values

**Historical Data (`dba_hist_*`):**
- `dba_hist_sqlstat` - Historical SQL statistics
- `dba_hist_snapshot` - AWR snapshot information

**Data Dictionary Views (`dba_*`):**
- `dba_objects` - Database objects metadata
- `dba_tables` - Table statistics
- `dba_indexes` - Index statistics
- `dba_sql_plan_baselines` - SQL plan management

**Packages:**
- `DBMS_XPLAN` - Execution plan display
- `DBMS_SQLTUNE` - SQL tuning advisor

### Required Privileges
- Scripts require `DBA` role or `/ as sysdba` connection
- Read access to dynamic performance views
- Read access to AWR repository (requires Diagnostics Pack license)

---

## Diagnostic Report Structure

The `sql_troubleshoot.sh` script generates a 10-section report:

1. **SQL Text and Basic Information** - Query text, schema, execution counts
2. **Current Execution Plan** - DBMS_XPLAN output with statistics
3. **SQL Performance History** - 7-day trend analysis
4. **Wait Events Analysis** - Resource contention identification
5. **Active Session Information** - Currently executing sessions
6. **Object Statistics (Tables)** - Table metadata and statistics
7. **Index Statistics** - Index health and usage
8. **Bind Variables** - Captured bind variable values
9. **SQL Tuning Artifacts** - Profiles and baselines
10. **Automated Recommendations** - Intelligent analysis and suggestions

### Recommendation Logic

**Thresholds:**
- `BUFFER_GETS > 100,000` → Warning about potential full table scans
- `DISK_READS > 10,000` → Warning about physical I/O issues
- `EXECUTIONS > 1,000` → Info about frequently executed queries

**Suggested Actions Always Include:**
- Review execution plan for inefficiencies
- Verify object statistics are current
- Analyze wait events for contention
- Review performance trends for degradation
- Consider SQL Tuning Advisor for persistent issues
- Enable detailed statistics gathering if needed

---

## Common Tasks for AI Assistants

### Adding New Diagnostic Sections

**Template:**
```bash
################################################################################
# N. Section Title
################################################################################
print_header "N. Section Title"
execute_sql "
SELECT column1, column2, column3
FROM relevant_view
WHERE sql_id = '$SQL_ID'
  AND other_conditions
ORDER BY relevant_column;
"
```

**Best Practices:**
- Increment section number sequentially
- Keep SQL queries focused and efficient
- Include relevant filtering and sorting
- Test against actual Oracle database
- Document the purpose of new sections

### Modifying Recommendation Logic

**Location:** Lines 203-245 of `sql_troubleshoot.sh`

**Pattern:**
1. Query statistics using `execute_sql`
2. Parse output using `awk` or `tail/head` combinations
3. Compare against thresholds
4. Use appropriate `print_*` function for output
5. Provide actionable recommendations

**Example:**
```bash
if [ "$METRIC" -gt THRESHOLD ]; then
    print_warning "Issue description ($METRIC)"
    echo "  Recommendation: Specific action to take"
fi
```

### Adding New Utility Scripts

**Naming Convention:**
- Use descriptive names with underscores: `feature_name.sh`
- Make scripts executable: `chmod +x script.sh`
- Include shebang: `#!/bin/bash`

**Required Elements:**
1. Header comment block with purpose and usage
2. `set -euo pipefail` for error handling
3. Input validation
4. Helper functions for consistent output
5. Exit code: `exit 0` on success, `exit 1` on failure

### Testing Changes

**Manual Testing:**
```bash
# Test with valid SQL_ID
./sql_troubleshoot.sh abc123xyz

# Test with custom ORACLE_SID
./sql_troubleshoot.sh abc123xyz PRODDB

# Test error handling
./sql_troubleshoot.sh  # Should show usage error
```

**Validation Checklist:**
- [ ] Script runs without errors
- [ ] All sections display data correctly
- [ ] Recommendations trigger appropriately
- [ ] Color output works in terminal
- [ ] Error messages are clear and actionable
- [ ] Oracle environment sources correctly

---

## Important Notes and Gotchas

### Oracle Environment

**Common Issues:**
- Oracle environment must be sourced before sqlplus
- `ORACLE_SID` must match actual database instance
- DBA privileges required - script won't work with limited accounts
- AWR data requires Oracle Diagnostics Pack license

**Environment Paths:**
- Standard: `/usr/local/bin/oraenv`
- Alternative: `/opt/oracle/product/*/bin/oraenv`
- Script automatically searches both locations

### Shell Scripting Gotchas

**Variable Quoting:**
- Always quote variables: `"$VARIABLE"` not `$VARIABLE`
- Prevents word splitting and glob expansion
- Especially critical for SQL_ID and paths

**Heredoc SQL:**
- Use `<<EOF` not `<<'EOF'` to allow variable interpolation
- Escape special characters if needed: `\$` for literal dollar signs
- SQL statements in heredocs should not be indented with tabs

**Arithmetic Comparisons:**
- Use `-gt`, `-lt`, `-eq` for integer comparisons
- Use quotes around variables: `[ "$VAR" -gt 100 ]`
- Ensure variables contain numbers before comparison

### Output Parsing

**Current Pattern:**
```bash
STATS=$(execute_sql "SELECT ..." | tail -2 | head -1)
VALUE=$(echo $STATS | awk '{print $N}')
```

**Why `tail -2 | head -1`:**
- Skips sqlplus output headers
- Extracts only data row
- Accounts for trailing newlines

**AWK Column Numbers:**
- Columns are 1-indexed: `{print $1}` is first column
- Whitespace-separated by default
- Adjust column numbers if query changes

### Git Workflow Reminders

**Critical Requirements:**
- Never push to main without review
- Branch names MUST follow `claude/*-<sessionId>` pattern
- Always commit before switching branches
- Use descriptive commit messages (focus on why, not what)
- Implement retry logic for network operations

**Commit Message Format:**
```
<imperative verb> <concise description>

Optional longer description if needed.
- Bullet points for multiple changes
- Explain why, not what (code shows what)
```

**Good Examples:**
- "Add proactive Oracle SQL_ID diagnosis and recommendation script"
- "Fix buffer gets threshold to reduce false positives"
- "Update wait events query to include wait class"

**Bad Examples:**
- "Update script" (too vague)
- "Fixed bug" (what bug?)
- "Changes" (non-descriptive)

---

## Repository State Information

**Last Updated:** 2026-01-14
**Current Branch:** `claude/add-claude-documentation-NuXtH`
**Repository Status:** Clean (no uncommitted changes)
**Recent Commits:**
- `accbfb8` - Add proactive Oracle SQL_ID diagnosis and recommendation script

**Statistics:**
- Total Scripts: 1
- Total Lines of Code: 249
- Languages: Bash (100%)

---

## Quick Reference

### File Locations
- Main script: `/home/user/2025/sql_troubleshoot.sh`
- Git config: `/home/user/2025/.git/config`
- SSH signing key: `/home/claude/.ssh/commit_signing_key.pub`

### Command Cheatsheet
```bash
# Run diagnostics
./sql_troubleshoot.sh <SQL_ID> [ORACLE_SID]

# Check git status
git status

# Create and push feature branch
git checkout -b claude/feature-name-<sessionId>
git add .
git commit -m "Descriptive message"
git push -u origin claude/feature-name-<sessionId>

# View Oracle environment
echo $ORACLE_SID
echo $ORACLE_HOME

# Test Oracle connectivity
sqlplus -S / as sysdba <<< "SELECT banner FROM v\$version;"
```

### Useful Oracle Queries
```sql
-- Find SQL_ID for problematic queries
SELECT sql_id, sql_text FROM v$sql WHERE sql_text LIKE '%your_query%';

-- Check if SQL_ID exists
SELECT COUNT(*) FROM v$sql WHERE sql_id = 'abc123xyz';

-- View current sessions
SELECT sid, serial#, username, status FROM v$session WHERE type = 'USER';
```

---

## Future Enhancements (Suggested)

**Potential Additions:**
1. **Testing Framework** - Automated testing with mock data
2. **Configuration File** - External config for thresholds and settings
3. **Output Formats** - JSON/XML output for automation
4. **Email Notifications** - Automated alerting for critical issues
5. **Trend Analysis** - Compare current vs. historical baselines
6. **Multi-SQL Support** - Batch processing of multiple SQL_IDs
7. **README.md** - User-facing documentation for end users
8. **Installation Script** - Automated setup and dependency checking

**Code Quality Improvements:**
1. Add unit tests for parsing functions
2. Implement logging to file option
3. Add verbose/debug output modes
4. Support for Oracle RAC environments
5. Cross-platform compatibility (Linux/Solaris/AIX)

---

## Support and Resources

**Oracle Documentation:**
- [Oracle Database Performance Tuning Guide](https://docs.oracle.com/en/database/)
- [Dynamic Performance Views Reference](https://docs.oracle.com/en/database/)
- [DBMS_XPLAN Package Documentation](https://docs.oracle.com/en/database/)

**Shell Scripting:**
- [Bash Reference Manual](https://www.gnu.org/software/bash/manual/)
- [ShellCheck](https://www.shellcheck.net/) - Shell script analysis tool
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)

**Git Workflow:**
- [Git Documentation](https://git-scm.com/doc)
- [Conventional Commits](https://www.conventionalcommits.org/)

---

## Changelog

| Date | Change | Commit |
|------|--------|--------|
| 2026-01-14 | Added CLAUDE.md documentation for AI assistants | (pending) |
| 2026-01-14 | Add proactive Oracle SQL_ID diagnosis script | accbfb8 |

---

**End of CLAUDE.md**

*This documentation is maintained for AI assistants working on this repository. Keep it updated when making significant changes to code structure, workflows, or conventions.*
