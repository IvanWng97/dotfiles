complete -c leetcode -n "__fish_use_subcommand" -s d -l debug -d 'debug mode'
complete -c leetcode -n "__fish_use_subcommand" -s h -l help -d 'Print help'
complete -c leetcode -n "__fish_use_subcommand" -s V -l version -d 'Print version'
complete -c leetcode -n "__fish_use_subcommand" -f -a "data" -d 'Manage Cache'
complete -c leetcode -n "__fish_use_subcommand" -f -a "edit" -d 'Edit question by id'
complete -c leetcode -n "__fish_use_subcommand" -f -a "exec" -d 'Submit solution'
complete -c leetcode -n "__fish_use_subcommand" -f -a "list" -d 'List problems'
complete -c leetcode -n "__fish_use_subcommand" -f -a "pick" -d 'Pick a problem'
complete -c leetcode -n "__fish_use_subcommand" -f -a "stat" -d 'Show simple chart about submissions'
complete -c leetcode -n "__fish_use_subcommand" -f -a "test" -d 'Test question by id'
complete -c leetcode -n "__fish_use_subcommand" -f -a "completions" -d 'Generate shell Completions'
complete -c leetcode -n "__fish_use_subcommand" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c leetcode -n "__fish_seen_subcommand_from data" -s d -l delete -d 'Delete cache'
complete -c leetcode -n "__fish_seen_subcommand_from data" -s u -l update -d 'Update cache'
complete -c leetcode -n "__fish_seen_subcommand_from data" -s h -l help -d 'Print help'
complete -c leetcode -n "__fish_seen_subcommand_from edit" -s l -l lang -d 'Edit with specific language' -r
complete -c leetcode -n "__fish_seen_subcommand_from edit" -s h -l help -d 'Print help'
complete -c leetcode -n "__fish_seen_subcommand_from exec" -s h -l help -d 'Print help'
complete -c leetcode -n "__fish_seen_subcommand_from list" -s c -l category -d 'Filter problems by category name
[algorithms, database, shell, concurrency]
' -r
complete -c leetcode -n "__fish_seen_subcommand_from list" -s p -l plan -d 'Invoking python scripts to filter questions' -r
complete -c leetcode -n "__fish_seen_subcommand_from list" -s q -l query -d 'Filter questions by conditions:
Uppercase means negative
e = easy     E = m+h
m = medium   M = e+h
h = hard     H = e+m
d = done     D = not done
l = locked   L = not locked
s = starred  S = not starred' -r
complete -c leetcode -n "__fish_seen_subcommand_from list" -s r -l range -d 'Filter questions by id range' -r
complete -c leetcode -n "__fish_seen_subcommand_from list" -s t -l tag -d 'Filter questions by tag' -r
complete -c leetcode -n "__fish_seen_subcommand_from list" -s s -l stat -d 'Show statistics of listed problems'
complete -c leetcode -n "__fish_seen_subcommand_from list" -s h -l help -d 'Print help'
complete -c leetcode -n "__fish_seen_subcommand_from pick" -s n -l name -d 'Problem name' -r
complete -c leetcode -n "__fish_seen_subcommand_from pick" -s p -l plan -d 'Invoking python scripts to filter questions' -r
complete -c leetcode -n "__fish_seen_subcommand_from pick" -s q -l query -d 'Filter questions by conditions:
Uppercase means negative
e = easy     E = m+h
m = medium   M = e+h
h = hard     H = e+m
d = done     D = not done
l = locked   L = not locked
s = starred  S = not starred' -r
complete -c leetcode -n "__fish_seen_subcommand_from pick" -s t -l tag -d 'Filter questions by tag' -r
complete -c leetcode -n "__fish_seen_subcommand_from pick" -s d -l daily -d 'Pick today\'s daily challenge'
complete -c leetcode -n "__fish_seen_subcommand_from pick" -s h -l help -d 'Print help'
complete -c leetcode -n "__fish_seen_subcommand_from stat" -s h -l help -d 'Print help'
complete -c leetcode -n "__fish_seen_subcommand_from test" -s h -l help -d 'Print help'
complete -c leetcode -n "__fish_seen_subcommand_from completions" -s h -l help -d 'Print help'
complete -c leetcode -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from data; and not __fish_seen_subcommand_from edit; and not __fish_seen_subcommand_from exec; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from pick; and not __fish_seen_subcommand_from stat; and not __fish_seen_subcommand_from test; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "data" -d 'Manage Cache'
complete -c leetcode -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from data; and not __fish_seen_subcommand_from edit; and not __fish_seen_subcommand_from exec; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from pick; and not __fish_seen_subcommand_from stat; and not __fish_seen_subcommand_from test; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "edit" -d 'Edit question by id'
complete -c leetcode -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from data; and not __fish_seen_subcommand_from edit; and not __fish_seen_subcommand_from exec; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from pick; and not __fish_seen_subcommand_from stat; and not __fish_seen_subcommand_from test; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "exec" -d 'Submit solution'
complete -c leetcode -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from data; and not __fish_seen_subcommand_from edit; and not __fish_seen_subcommand_from exec; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from pick; and not __fish_seen_subcommand_from stat; and not __fish_seen_subcommand_from test; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "list" -d 'List problems'
complete -c leetcode -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from data; and not __fish_seen_subcommand_from edit; and not __fish_seen_subcommand_from exec; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from pick; and not __fish_seen_subcommand_from stat; and not __fish_seen_subcommand_from test; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "pick" -d 'Pick a problem'
complete -c leetcode -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from data; and not __fish_seen_subcommand_from edit; and not __fish_seen_subcommand_from exec; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from pick; and not __fish_seen_subcommand_from stat; and not __fish_seen_subcommand_from test; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "stat" -d 'Show simple chart about submissions'
complete -c leetcode -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from data; and not __fish_seen_subcommand_from edit; and not __fish_seen_subcommand_from exec; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from pick; and not __fish_seen_subcommand_from stat; and not __fish_seen_subcommand_from test; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "test" -d 'Test question by id'
complete -c leetcode -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from data; and not __fish_seen_subcommand_from edit; and not __fish_seen_subcommand_from exec; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from pick; and not __fish_seen_subcommand_from stat; and not __fish_seen_subcommand_from test; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "completions" -d 'Generate shell Completions'
complete -c leetcode -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from data; and not __fish_seen_subcommand_from edit; and not __fish_seen_subcommand_from exec; and not __fish_seen_subcommand_from list; and not __fish_seen_subcommand_from pick; and not __fish_seen_subcommand_from stat; and not __fish_seen_subcommand_from test; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'