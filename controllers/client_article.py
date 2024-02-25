#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, abort, flash, session

from connexion_db import get_db

client_article = Blueprint('client_article', __name__,
                           template_folder='templates')


@client_article.route('/client/index')
@client_article.route('/client/article/show')  # remplace /client
def client_article_show():  # remplace client_index
    mycursor = get_db().cursor()
    id_client = session['id_user']

    sql = '''SELECT * FROM ski'''

    list_param = []
    condition_and = ""
    # utilisation du filtre
    sql3 = ''' prise en compte des commentaires et des notes dans le SQL    '''
    articles = []
    mycursor.execute(sql)
    articles = mycursor.fetchall()
    # pour le filtre
    types_article = []
    sql = '''SELECT * FROM type_ski'''
    mycursor.execute(sql)
    types_article = mycursor.fetchall()

    sql = '''SELECT * FROM ligne_panier
    WHERE utilisateur_id = %s'''
    mycursor.execute(sql, (id_client,))
    articles_panier = mycursor.fetchall()

    if len(articles_panier) >= 1:
        sql = ''' calcul du prix total du panier '''
        prix_total = None
    else:
        prix_total = None
    return render_template('client/boutique/panier_article.html'
                           , articles=articles
                           , articles_panier=articles_panier
                           , prix_total=prix_total
                           , items_filtre=types_article
                           )
