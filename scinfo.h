/*
 * iNalyzer5
 * https://github.com/appsec-labs/iNalyzer
 *
 * Security assesment framework for iOS application
 * by Chilik Tamir @_coreDump
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

/*
 Generates SC_Info keys (.sinf and .supp)
 see http://hackulo.us/wiki/SC_Info
*/

void *create_atom(char *name, int len, void *content);
void *coalesced_atom(int amount, uint32_t name, ...);
void *combine_atoms(char *name, int amount, ...);
void *generate_sinf(int appid, char *cracker_name, int vendorID);
void *generate_supp(uint32_t *suppsize);