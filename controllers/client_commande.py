#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g
from datetime import datetime
from connexion_db import get_db

client_commande = Blueprint('client_commande', __name__,
                            template_folder='templates')


# validation de la commande : partie 2 -- vue pour choisir les adresses (livraision et facturation)
@client_commande.route('/client/commande/valide', methods=['POST'])
def client_commande_valide():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    sql = '''SELECT * FROM ligne_panier WHERE utilisateur_id = %s
    '''
    articles_panier = []
    mycursor.execute(sql, (id_client,))
    articles_panier = mycursor.fetchall()
    if len(articles_panier) >= 1:
        sql = '''SELECT SUM(prix * quantite) AS total FROM ligne_panier WHERE utilisateur_id = %s'''
        mycursor.execute(sql, (id_client,))
        result = mycursor.fetchone()

        prix_total = result['total']
    else:
        prix_total = None
    # etape 2 : selection des adresses
    sql = '''SELECT * FROM adresse WHERE utilisateur_id = %s'''
    mycursor.execute(sql, (id_client,))
    adresses = mycursor.fetchall()
    return render_template('client/boutique/panier_validation_adresses.html'
                           , adresses=adresses
                           , articles_panier=articles_panier
                           , prix_total=prix_total
                           , validation=1
                           # , id_adresse_fav=id_adresse_fav
                           )


@client_commande.route('/client/commande/add', methods=['POST'])
def client_commande_add():
    mycursor = get_db().cursor()

    # choix de(s) (l')adresse(s)

    id_client = session['id_user']
    sql = '''SELECT * FROM ligne_panier WHERE utilisateur_id = %s'''
    mycursor.execute(sql, (id_client,))
    items_ligne_panier = []
    items_ligne_panier = mycursor.fetchall()

    # if items_ligne_panier is None or len(items_ligne_panier) < 1:
    #     flash(u'Pas d\'articles dans le ligne_panier', 'alert-warning')
    #     return redirect('/client/article/show')
    # https://pynative.com/python-mysql-transaction-management-using-commit-rollback/
    # a = datetime.strptime('my date', "%b %d %Y %H:%M")

    sql = '''SELECT SUM(quantite) AS total_articles FROM ligne_panier WHERE utilisateur_id = %s'''
    mycursor.execute(sql, (id_client,))
    result = mycursor.fetchone()
    nbr_articles = result['total_articles']

    sql = '''SELECT SUM(prix * quantite) AS prix_total FROM ligne_panier WHERE utilisateur_id = %s'''
    mycursor.execute(sql, (id_client,))
    result = mycursor.fetchone()
    prix_total = result['prix_total']

    sql = '''INSERT INTO commande(date_achat, utilisateur_id, etat_id, nbr_articles, prix_total)
    VALUES (DATE(NOW()), %s, %s, %s, %s)'''
    mycursor.execute(sql, (id_client, 1, nbr_articles, prix_total,))

    sql = '''SELECT LAST_INSERT_ID() AS last_insert_id'''
    mycursor.execute(sql)
    result = mycursor.fetchone()
    last_insert_id = result['last_insert_id'] if result else None
    # numéro de la dernière commande
    for item in items_ligne_panier:
        sql = '''DELETE FROM ligne_panier WHERE id_ski = %s AND utilisateur_id = %s'''
        mycursor.execute(sql, (item['id_ski'], id_client,))
        get_db().commit()
        sql = '''INSERT INTO ligne_commande(commande_id, id_ski, prix, quantite, nom_ski)
        VALUES(%s, %s, %s, %s, %s)'''
        mycursor.execute(sql, (last_insert_id, item['id_ski'], item['prix'], item['quantite'], item['nom_ski']))

    get_db().commit()
    flash(u'Commande ajoutée', 'alert-success')
    return redirect('/client/article/show')


@client_commande.route('/client/commande/show', methods=['get', 'post'])
def client_commande_show():
    mycursor = get_db().cursor()
    id_client = session['id_user']
    sql = '''SELECT * FROM commande WHERE utilisateur_id = %s ORDER BY etat_id, date_achat DESC'''
    mycursor.execute(sql, (id_client,))
    commandes = []
    commandes = mycursor.fetchall()

    articles_commande = None
    commande_adresses = None
    id_commande = request.args.get('id_commande', None)
    if id_commande is not None:
        print(id_commande)
        sql = '''SELECT * , (quantite * prix) AS prix_ligne FROM ligne_commande WHERE commande_id = %s'''
        mycursor.execute(sql, (id_commande,))
        articles_commande = mycursor.fetchall()

        # partie 2 : selection de l'adresse de livraison et de facturation de la commande selectionnée
        sql_commande_adresses = '''SELECT * FROM adresse WHERE  = %s'''
        mycursor.execute(sql_commande_adresses, (id_commande,))
        commande_adresses = mycursor.fetchone()

    return render_template('client/commandes/show.html'
                           , commandes=commandes
                           , articles_commande=articles_commande
                           , commande_adresses=commande_adresses
                           )
