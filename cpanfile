requires 'perl', '5.014';

requires 'Getopt::EX', 'v1.5.1';
requires 'List::Util', '1.45';
requires 'Text::VisualWidth::PP', '0.05';
requires 'Unicode::EastAsianWidth::Detect';

on 'test' => sub {
    requires 'Test::More', '0.98';
};
