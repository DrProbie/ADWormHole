. $PSScriptRoot\1.ps1

Describe 'TimesTwo' {
    Context 'Numbers' {
        It 'Multiplies numbers properly' {
            TimesTwo 2 | Should be 4
        }
    }

    Context 'Strings' {
        It 'Multiplies strings properly' {
            TimesTwo 'Test' | Should BeExactly 'TestTest'
        }
    }

    Context 'Arrays' {
        It 'Multiplies arrays properly' {
            $array = 1..2
            $result = TimesTwo $array

            $result.Count | Should Be 4
            $result[0] | Should Be 1
            $result[1] | Should Be 2
            $result[2] | Should Be 1
            $result[3] | Should Be 2
        }
    }
}