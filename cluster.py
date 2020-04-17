import pandas as pd
import igraph as ig
import numpy as np
#%%
# Read files
nodes_df = pd.read_csv('../data/citation_nodes-0.txt', sep='\t', 
                       dtype={'abstract': 'str'}, low_memory=False)
edges_df = pd.read_csv('../data/citation_edges-0.txt', sep='\t')

#%%
# Create graph
G = ig.Graph.DictList(
          vertices=nodes_df.to_dict('records'),
          edges=edges_df.to_dict('records'),
          directed=True,
          vertex_name_attr='id',
          edge_foreign_keys=('citing_pub_id', 'cited_pub_id'));
del G.es['citing_pub_id']
del G.es['cited_pub_id']

#%%
# Get weakly connected component
H = G.components(mode='weak').giant()

degree = np.array(H.degree(mode='out'))
H.es['weight'] = [1.0/degree[e.source] for e in H.es]
H.to_undirected(combine_edges='sum')

#%%
# Cluster publications
import random
random.seed(0)
ig.set_random_number_generator(random)

res_params = [2e-5, 1e-5]
cluster_solutions = [None]*len(res_params)
graph = H
for idx, res in enumerate(res_params):
  cluster_solutions[idx] = graph.community_leiden(resolution_parameter=res, n_iterations=10,
                                weights='weight', 
                                node_weights='weight')
  graph = cluster_solutions[idx].cluster_graph(combine_vertices={'weight': 'sum'},
                                                 combine_edges={'weight': 'sum'})

#%%
# Make dataframe with clustering solution
pubs_df = nodes_df.set_index('id')
membership = np.arange(H.vcount())
for idx, clusters in enumerate(cluster_solutions):
  tmp_membership = np.array(clusters.membership)
  membership = np.array([tmp_membership[c] for c in membership])
  pubs_df.loc[H.vs['id'],'clusters_{}'.format(idx)] = membership

pubs_df = pubs_df.loc[H.vs['id'],:]
pubs_df = pubs_df[pubs_df['weight'] == 1]

for idx in range(len(cluster_solutions)):
  col = 'clusters_{}'.format(idx)
  pubs_df[col] = pubs_df[col].astype('int')

#%%
# Write results
pubs_df.to_csv('cluster_solutions_pubs.txt', index=True, sep='\t')

cols = ['clusters_{}'.format(i) for i in range(len(cluster_solutions))]
pubs_df[cols].to_csv('cluster_solutions.txt', index=True, sep='\t')