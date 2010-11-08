package chnforo;
use Dancer ':syntax';
use Dancer::Plugin::Database;

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

get '/hello/:name' => sub {
     # do something important here
     #return "Hello ".params->{name};
     template 'hola';
};

get '/articulo/view/:id' => sub {
        my $sth = database->prepare(
            'select * from entradas where id = ?',
        );
        my $texto = "empty";
        $sth->execute(params->{id});
        my $articulo = $sth->fetchrow_hashref;
        $texto = $$articulo{'texto'};
        $texto =~ s/Reproduced in the form of a hyperlink when you identify the source and author information in the article and the statement//;
        template 'ver_articulo', { texto => $texto, articulo => $articulo };
    };

true;
