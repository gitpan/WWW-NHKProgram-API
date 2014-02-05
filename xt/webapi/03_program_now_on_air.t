#!perl

use strict;
use warnings;
use utf8;
use JSON ();
use WWW::NHKProgram::API;

use Test::Deep;
use Test::More;

my $api_key = $ENV{NHK_PROGRAM_API_KEY};
plan skip_all => "API_KEY is not given." unless $api_key;

my $client = WWW::NHKProgram::API->new(
    api_key => $api_key,
);

subtest 'Get response as hashref certainly' => sub {
    my $program_now = $client->now_on_air({
        area    => 130,
        service => 'g1',
    });
    ok $program_now->{previous};
    ok $program_now->{present};
    ok $program_now->{following};
};

subtest 'Get response as raw JSON certainly' => sub {
    my $json = $client->now_on_air_raw({
        area    => '東京',
        service => 'ＮＨＫ総合１',
    });

    my $program_now = JSON::decode_json($json)->{nowonair_list}->{g1};
    ok $program_now->{previous};
    ok $program_now->{present};
    ok $program_now->{following};
};

done_testing;

