Describe 'Example' {
    It 'Compares two strings with Case Sensitivity' {
        'This is a Test' | Should not BeExactly 'This is a test'
    }
}