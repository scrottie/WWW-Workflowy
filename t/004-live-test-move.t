
use strict;
use warnings;

use lib 'lib', '../lib'; #  XXX

use Test::More;

use WWW::Workflowy;

my $wf = WWW::Workflowy->new(
    url => 'https://workflowy.com/shared/b141ebc1-4c8d-b31a-e3e8-b9c6c633ca25/',
);

my $node1_id = $wf->create(
    parent_id => 'b141ebc1-4c8d-b31a-e3e8-b9c6c633ca25',
    priority  => 0,    # which position in the list of items under the parent to insert this node
    text      => "Tell Mary Poppins about the squash " . int rand 10000,
);

ok $node1_id, "create() returned a value for node 1";

my $node2_id = $wf->create(
    parent_id => 'b141ebc1-4c8d-b31a-e3e8-b9c6c633ca25',
    priority  => 1,    # which position in the list of items under the parent to insert this node
    text      => "Eat yourself out of the hole you made " . int rand 10000,
);

ok $node2_id, "create() returned a value for node 2";

my $node3_id = $wf->create(
    parent_id => $node2_id,   # child of $node2
    priority  => 0,    # which position in the list of items under the parent to insert this node
    text      => "Vegetables didn't stand a chance " . int rand 10000,
);

ok $node3_id, "create() returned a value for node 3";


warn $wf->dump; # XXX


$wf->move(
    node_id => $node2_id,
    priority => 0,
);

my $checked_again_after_sync;

check_again_after_sync:

do {
    my ( $parent_node, $node, $priority, $siblings ) = WWW::Workflowy::_find_parent($wf->outline, $node2_id ) or die;
    ok $priority == 0, 'node2 moved to top slot';
};

do {
    my ( $parent_node, $node, $priority, $siblings ) = WWW::Workflowy::_find_parent($wf->outline, $node1_id ) or die;
    ok $priority == 1, 'node1 moved to second slot';
};

do {
    my ( $parent_node, $node, $priority, $siblings ) = WWW::Workflowy::_find_parent($wf->outline, $node3_id ) or die;
    ok $priority == 0, 'node3 still exists';
    ok $parent_node->{id} eq $node2_id, 'node3 still a child of node2';
};

if( ! $checked_again_after_sync ) {
    # sync with the remote server, re-pull the outline, and make sure the server's copy is what we expect
    sleep $wf->polling_interval;
    $wf->sync;    # send changes up
    $wf->fetch;   # blow away our copy with the server's copy
    $checked_again_after_sync = 1;
    goto check_again_after_sync;
}

done_testing;

